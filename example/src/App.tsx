import HomeScreen from './HomeScreen';
import OtherScreen from './OtherScreen';
import { createStaticNavigation } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { enableFreeze } from 'react-native-screens';

enableFreeze(true);
export type RootStackParamList = {
  Home: undefined;
  Other: undefined;
};

const RootStack = createNativeStackNavigator<RootStackParamList>({
  initialRouteName: 'Home',
  screens: {
    Home: {
      screen: HomeScreen,
    },
    Other: OtherScreen,
  },
});

const Navigation = createStaticNavigation(RootStack);

export default function App() {
  return <Navigation />;
}
