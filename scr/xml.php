<?php

if(isset($_GET['te']) && isset($_GET['de']) && $_GET['te'] == 'ok' && $_GET['de'] = 'ok'){
    header('Content-type: application/xml');
    //数据可以从数据库是读取
    $data_array = array(
     array("location"=>"mp3/moldau.mp3","creator"=>"Bedrich Smetana","album"=>"","title"=>"","annotation"=>"","duration"=>"","image"=>"","info"=>"","link"=>""),
     array("location"=>"mp3/moldau.mp3","creator"=>"Cesaria Evora","album"=>"","title"=>"","annotation"=>"","duration"=>"","image"=>"","info"=>"","link"=>""),
     array("location"=>"mp3/moldau.mp3","creator"=>"Russian Red Army Choir","album"=>"","title"=>"","annotation"=>"","duration"=>"","image"=>"","info"=>"","link"=>"")
    );
    //  属性数组
    /*$attribute_array = array(
        'title' => array(
        'size' => 1
        )
    );
    */


    //  创建一个XML文档并设置XML版本和编码。。
    $dom=new DomDocument('1.0', 'utf-8');
    //  创建根节点
    $lct = $dom->createElement('lct');
    $dom->appendChild($lct);
    /////////////
    $title=$dom->createElement('title');
    $lct->appendChild($title);
    $text = $dom->createTextNode('Ounage lct');
    $title->appendChild($text);
    $reftime=$dom->createElement('reftime');
    $lct->appendChild($reftime);
    $text = $dom->createTextNode(60);
    $reftime->appendChild($text);
    /////////////////////
    //shebeiwenzi
    $shebeiwenzi=$dom->createElement('shebeiwenzi');
    $lct->appendChild($shebeiwenzi);
    //
    foreach ($data_array as $data) {
        $item = $dom->createElement('item');
        $name = $dom->createElement('name');
        $t = $dom->createTextNode('你好');
        $name->appendChild($t);
        $x_pos = $dom->createElement('x_pos');
        $x = $dom->createTextNode(500);
        $x_pos->appendChild($x);
        $y_pos = $dom->createElement('y_pos');
        $y = $dom->createTextNode(100);
        $y_pos->appendChild($y);
        $shebeiwenzi->appendChild($item);
    }
    echo $dom->saveXML();
    function create_item($dom, $item, $data, $attribute) {
        if (is_array($data)) {
            foreach ($data as $key => $val) {
                //  创建元素
                $$key = $dom->createElement($key);
                $item->appendChild($$key);

                //  创建元素值
                $text = $dom->createTextNode($val);
                $$key->appendChild($text);

                if (isset($attribute[$key])) {
                //  如果此字段存在相关属性需要设置
                    foreach ($attribute[$key] as $akey => $row) {
                        //  创建属性节点
                        $$akey = $dom->createAttribute($akey);
                        $$key->appendChild($$akey);

                        // 创建属性值节点
                        $aval = $dom->createTextNode($row);
                        $$akey->appendChild($aval);
                    }
                }   //  end if
            }
        }   //  end if
    }   //  end function
}