Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61862639584
	for <lists+live-patching@lfdr.de>; Sat, 26 Nov 2022 11:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiKZKqa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 26 Nov 2022 05:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKZKq0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 26 Nov 2022 05:46:26 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8878CBE37
        for <live-patching@vger.kernel.org>; Sat, 26 Nov 2022 02:46:25 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3a7081e3b95so62427247b3.1
        for <live-patching@vger.kernel.org>; Sat, 26 Nov 2022 02:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6uPZo6V94trCgdT45DV4UtMD9jZ9uTpj89T0LyAAZY=;
        b=jcIxIq7yERciagBG94BY4qxHcJcAXFKG3hDFCZuTaGqDzGiUT7A9UonJWFDN0C1sgV
         Ljmsw+JjliawFxpRzS3gyvPgjy/qqxGveerC/plbCC/4g+3V6QyaaMkNrHTjNxz6APXb
         dG0mR0+u56ZZuktvyjtFA+EJvbeprEFzRkpvo2LXVAXB5EAz/uKx8pvimD3iaWAzF6rK
         Aodm6oc5SrBGEP1JZMM4xOfmDiHVW48F4kFvZiZo7td8cCez1Cfy1K7pBmF8WoUEvaJC
         C4eKaXvLdEGpWZPyPb97QB4zRo3bk4TFIyy9fykXufD8sM+xJu0L9uP/Q8BIkXO/MGwi
         +UdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6uPZo6V94trCgdT45DV4UtMD9jZ9uTpj89T0LyAAZY=;
        b=KK6Xby66iA3PqUtiQhlW+6g/pLm3HKK1n310Hh6FiOwIDupFDKcAnCI5rCVodgWIf6
         l59bA9NsKr+XmhSRF/CtwwPjSQUufg94KhS2K8xnfXv6N4rdcWoemjm5cKzbjdfNPVAd
         OKAUTgkRHNrPWDbKQXXT6vXbEkY7CjNkDcBO6K8nmEvoVeuxfiYjN2p6rMOGUUYEWpHB
         fVs+dhbqzYQebB4skdO44PG4XRCcQWTNJNKrlgi5jvlcBNdQRQOXEVVn/CxKcR3UPZ1Y
         TgkicJtVA7SRMb1+9CE1AUXW009pje3ArRm7Nb/HbVb9IwdnGY1kEdCJiD+bzvNEIrmv
         92BA==
X-Gm-Message-State: ANoB5plQYKLDdaZRlD5z+SkyoQLiGZNkHVTDeHHEr+DaU1floPhvG7U+
        qMiy/xPDx/1uUFU7L9RlpZHhfHkh3xxHaboKVng=
X-Google-Smtp-Source: AA0mqf5qJKZ4a5CozeSQY39uY2hmIyzAhAJe//3thesWNzc1aM/WHEUw2Eb02cITZPnpcyhFZhNfA4Se2UwXXbOfzGU=
X-Received: by 2002:a05:690c:786:b0:36b:c8e:24fd with SMTP id
 bw6-20020a05690c078600b0036b0c8e24fdmr22764370ywb.413.1669459584590; Sat, 26
 Nov 2022 02:46:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7108:393:b0:251:38ab:3bbc with HTTP; Sat, 26 Nov 2022
 02:46:24 -0800 (PST)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <ninacoulibaly01@gmail.com>
Date:   Sat, 26 Nov 2022 10:46:24 +0000
Message-ID: <CALav4vSPs7J6=G8mf_LACh0ZGG7pAGgAQ=D-rKtVMy=qT=i=_w@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

-- 
Dear

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibaly
