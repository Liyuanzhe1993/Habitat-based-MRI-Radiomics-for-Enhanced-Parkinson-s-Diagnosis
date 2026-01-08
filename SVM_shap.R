library(data.table)
library(magrittr)
library(tidyverse)
library(fastshap)
library(e1071)
library(pROC)

# 读取数据集
train_data <- fread("train_selected_value.csv")

# 分离特征和标签
train_data_feature <- train_data[, -which(names(train_data) == "label"), with = FALSE]
train_data_label <- as.factor(train_data$label)

# 训练SVM模型
model <- svm(train_data_feature, train_data_label, probability = TRUE)

# 在训练数据上预测概率
pred_prob <- attr(predict(model, newdata = train_data_feature, probability = TRUE), "probabilities")[,2]

# 计算并绘制ROC曲线
roc <- roc(train_data_label, pred_prob)
plot(roc, col = "blue", main = "ROC Curve", xlab = "False Positive Rate", ylab = "True Positive Rate", print.auc = TRUE, legacy.axes = TRUE)

# 绘制SHAP图的函数
plot_shap <- function(model, newdata){
  shap <- explain(model, X = newdata, nsim = 10, pred_wrapper = function(model, newdata){
    attr(predict(model, newdata = newdata, probability = TRUE), "probabilities")[,2]
  })
  
  shap_handle <- shap %>% as.data.frame() %>% mutate(id = 1:n()) %>% pivot_longer(cols = -id, values_to = "shap")
  data2 <- newdata %>% mutate(id = 1:n()) %>% pivot_longer(cols = -id)
  
  shap_scale <- shap_handle %>%
    left_join(data2) %>%
    rename("feature" = "name") %>%
    group_by(feature) %>%
    mutate(value = (value - min(value)) / (max(value) - min(value)))
  
  # 计算每个特征的平均绝对SHAP值，并按此排序
  feature_importance <- shap_scale %>%
    group_by(feature) %>%
    summarize(mean_abs_shap = mean(abs(shap))) %>%
    arrange(desc(mean_abs_shap))
  
  shap_scale <- shap_scale %>%
    mutate(feature = factor(feature, levels = rev(feature_importance$feature)))
  
  p <- ggplot(data = shap_scale, aes(x = shap, y = feature, color = value)) +
    geom_jitter(size = 1.5, height = 0.1, width = 0) +
    scale_color_gradient(low = "blue", high = "red", breaks = c(0, 1), labels = c("Low", "High"),
                         guide = guide_colorbar(barwidth = 1, barheight = 10),
                         name = "Feature value",
                         aesthetics = c("color")) + 
    theme_minimal() +
    theme(axis.text.y = element_text(size = 10),
          axis.line.y = element_blank(),
          axis.line.x = element_line(colour = "black", size = 0.8),
          axis.ticks = element_line(colour = "black", size = 0.8)) +
    labs(title = "SHAP Beewarm Plot",
         x = "SHAP value (impact on model output)",
         y = "Features") +
    geom_vline(xintercept = 0, color = "black", size = 0.8) # 加粗0.0处的纵坐标线
  
  return(list(shap_plot = p, feature_importance = feature_importance))
}

# 获取SHAP图和特征重要性
shap_results <- plot_shap(model, train_data_feature)
shap_plot <- shap_results$shap_plot
feature_importance <- shap_results$feature_importance

# 绘制特征重要性柱状图
importance_plot <- ggplot(data = feature_importance, aes(x = reorder(feature, mean_abs_shap), y = mean_abs_shap)) +
  geom_bar(stat = "identity", fill = "#B9181A", width = 0.5) + # 调整柱状图宽度
  coord_flip() +
  xlab("Feature") +
  ylab("Mean(|SHAP value|)") +
  ggtitle("SHAP Bar Plot") +
  theme_minimal() +
  theme(axis.line.x = element_line(size = 0.8, colour = "black"),
        axis.line.y = element_blank(), # 移除默认纵坐标轴线
        axis.ticks.x = element_line(size = 0.8, colour = "black"),
        axis.ticks.y = element_blank()) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  geom_hline(yintercept = 0, color = "black", size = 0.8) + # 在0.0处添加纵坐标轴线
  geom_text(aes(label = sprintf("%.3f", mean_abs_shap)), 
            position = position_stack(vjust = 0.5), 
            color = "black", 
            size = 3.5, 
            hjust = -0.1) # 在柱状图右侧添加标签

# 打印SHAP图和特征重要性图
print(shap_plot)
print(importance_plot)

