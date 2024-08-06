# 8/6/24
## Make fake data frame to use as sample in QBR QC .qmd

library(tidyverse)

# Make vectors to randomly choose from
Category_clean <- c('HSI','Device','ACP','Brand/Loyalty','Onboarding','Service','Other','Enterprise','VAS/Revenue')
Cadence_clean <- c('Ad Hoc','Recurring')
Channel_clean <- c('Email','SMS','Push')
# this is `Action Code` (derive language from last two characters)
action_code <- c('HAPPYEN','HAPPYES')
# this is `Clean Campaign Name` --> actually, make sep vectors to choose from, based on Category_clean
#Campaign_name_clean <- c('Anniversary','T Life Messaging','Samsung A7 Lite','Samsung A15','Pre2Post Ad Hoc','Pre2Post Recurring','HSI GW','HSI GW Promo','HSI Onboarding','HSI Voice Onboarding','Summer Splash', 'Holiday Cheer', 'Back to School', 'Spring Refresh', 'Fall Festival', 'Winter Wonderland', 'Tech Titans', 'Gadget Galore', 'Fitness First', 'Fashion Forward', 'Eco Warrior', 'Digital Dreams', 'Healthy Habits', 'Adventure Awaits', 'Home Comforts', 'Pet Paradise', 'Luxury Living', 'Budget Savers', 'Travel Treasures', 'Weekend Warriors', 'Culinary Creations', 'Beauty Bliss', 'Music Magic', 'Artistic Expressions', 'Sports Fanatics', 'Outdoor Explorers', 'Urban Chic', 'Vintage Vibes', 'Family Fun', 'Young & Free', 'Bold & Brave', 'Serene Spaces', 'Creative Minds', 'Innovation Nation', 'Tech Savvy', 'Green Thumb', 'Fitness Frenzy', 'Mindful Moments', 'Wellness Wave', 'Joyful Journeys', 'Gourmet Delights', 'Style Statements', 'Music Mania', 'Crafty Creations', 'Fit & Fab', 'Savvy Shopper', 'Global Explorer', 'Luxury Lane', 'Zen Zone', 'Digital Discoveries')
campaign_hsi <- c('HSI GW','HSI GW Promo','HSI Onboarding','HSI Voice Onboarding')
campaign_device <- c('Anniversary','T Life Messaging','Samsung A7 Lite','Samsung A15','Pre2Post Ad Hoc','Pre2Post Recurring')
campaign_acp <- c('Summer Splash', 'Holiday Cheer', 'Back to School', 'Spring Refresh', 'Fall Festival', 'Winter Wonderland')
campaign_brand <- c('Tech Titans', 'Gadget Galore', 'Fitness First', 'Fashion Forward', 'Eco Warrior', 'Digital Dreams', 'Healthy Habits')
campaign_onb <- c('Adventure Awaits', 'Home Comforts', 'Pet Paradise', 'Luxury Living', 'Budget Savers', 'Travel Treasures', 'Weekend Warriors')
campaign_enterprise <- c('Culinary Creations', 'Beauty Bliss', 'Music Magic', 'Artistic Expressions', 'Sports Fanatics')
campaign_vas <- c('Outdoor Explorers', 'Urban Chic', 'Vintage Vibes', 'Family Fun', 'Young & Free', 'Bold & Brave', 'Serene Spaces', 'Creative Minds', 'Innovation Nation')

# Make data frame
data.frame(JMID = sample(1000:1017,10000,replace = T)) %>%
  # Generate 4 cols of numbers, then use biggest for Sent, smallest for Clicks (probably will be numD because smallest, but no guarantees)
  # (obviously this doesn't give the most realistic data, but at least logically possible; e.g. force more Sends than Delivered)
  add_column(numA = sample(5000:100000, nrow(.), replace = TRUE),
            numB = sample(5000:100000, nrow(.), replace = TRUE),
            numC = sample(5000:100000, nrow(.), replace = TRUE),
            numD = sample(500:10000, nrow(.), replace = TRUE)) %>% 
  rowwise() %>% # Need to do sort for each row, not once for overall df
  mutate(Sent = sort(c_across(numA:numD), decreasing = TRUE)[1],
        Delivered = sort(c_across(numA:numD), decreasing = TRUE)[2],
        Opens = sort(c_across(numA:numD), decreasing = TRUE)[3],
        `Total Clicks` = sort(c_across(numA:numD), decreasing = TRUE)[4]) %>%
  ungroup() %>%
  select(-starts_with('num')) %>%
    add_column(Category_clean = sample(Category_clean, nrow(.), replace = TRUE),
              Cadence_clean = sample(Cadence_clean, nrow(.), replace = TRUE),
              Channel_clean = sample(Channel_clean, nrow(.), replace = TRUE),
            `Action Code` = sample(action_code,nrow(.), replace= T)) %>%
  rowwise() %>% # Need to rando select for each time category clean is identified in a row, rather than once for all rows that are 'HSI"
  mutate(`Clean Campaign Name` = case_when(
    Category_clean == 'HSI' ~ sample(campaign_hsi,1,replace = T),
    Category_clean == 'Device' ~ sample(campaign_device,1),
    Category_clean == 'ACP' ~ sample(campaign_acp,1),
    Category_clean == 'Brand/Loyalty' ~ sample(campaign_brand,1),
    Category_clean == 'Onboarding' ~ sample(campaign_onb,1),
    Category_clean == 'Enterprise' ~ sample(campaign_enterprise,1),
    Category_clean == 'VAS/Revenue' ~ sample(campaign_vas,1),
    TRUE ~ 'Some campaign'
  )) -> df_fake

# Save so can read into .qmd
write_csv(df_fake,'fake_qbr.csv')
df_fake %>%
  glimpse()

