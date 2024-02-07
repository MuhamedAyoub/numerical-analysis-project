"use server"

import { SERVER_HOST } from "@/config/http";
import styles from "@/components/chapters/sixth/styles.module.css";

function fetchBlurredImages(data: FormData) {
    return(fetch(`${SERVER_HOST}/chapter3`, {
        method: "POST",
        body: data,
    }))
}

export default function SixthChapter() {
    return (
        <div className="flex flex-column">
            <div className={`${styles.form}`}>
                <form action={fetchBlurredImages}>
                    <label htmlFor="image">Upload image</label>
                    <input type="file" id="image" name="image" accept="image/png, image/jpeg, image/svg"/>
                </form>
            </div>
            <div className="output overflow-scroll grid-cols-2 grid-rows-2">
            </div>
        </div>
    );
}
