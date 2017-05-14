require 'ffaker'

station = ["三島駅", "恵比寿駅", "武蔵小杉駅", "品川駅", "黒酢駅", "五月雨駅",
 "浜松駅", "沼津駅", "静岡駅", "三つ葉駅", "海老駅", "寿司食べたい駅", "寿司三昧駅"]

for s in station do
  Station.create(station: s)
end
