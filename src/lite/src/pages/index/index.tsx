import { View, Text } from '@tarojs/components'
import { useLoad, navigateTo } from '@tarojs/taro'
import './index.scss'

const entries = [
  {
    title: '标准范畴',
    desc: '两个九宫格 18 格 + Context、Archive',
    url: '/pages/category/category'
  }
]

export default function Index () {
  useLoad(() => {
    console.log('Page loaded.')
  })

  return (
    <View className='index'>
      <View className='index__head'>
        <Text className='index__title'>量潮元云</Text>
        <Text className='index__sub'>系统的元认知工具 · 只读展示</Text>
      </View>
      {entries.map((e) => (
        <View
          key={e.url}
          className='index__card'
          onClick={() => navigateTo({ url: e.url })}
        >
          <Text className='index__card-title'>{e.title}</Text>
          <Text className='index__card-desc'>{e.desc}</Text>
        </View>
      ))}
    </View>
  )
}
