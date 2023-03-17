import { Avatar, Pressable } from "native-base";
import { useState } from "react";
import { useNavigate } from "react-router";
import { AuthPopup } from "./auth-popup";

export function Header() {
  const [showBox, setShowBox] = useState(false);
  let navigate = useNavigate();

  return (
    <>
      <div className="header">
        <img
          onClick={() => navigate("/")}
          src="https://results.eci.gov.in/ResultAcGenMar2022/img/logo.png"
          alt="logo"
        />
        <Pressable onPress={() => setShowBox((showBox) => !showBox)}>
          <Avatar
            bg="indigo.500"
            size={{ base: "md", md: "10" }}
            source={{
              uri: "https://cdn-icons-png.flaticon.com/128/149/149071.png",
            }}
          >
            JB
          </Avatar>
        </Pressable>
      </div>
      {showBox && <AuthPopup setShowBox={setShowBox} />}
    </>
  );
}
