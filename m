Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B416FB62F
	for <lists+live-patching@lfdr.de>; Mon,  8 May 2023 20:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjEHSEO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 8 May 2023 14:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbjEHSEN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 8 May 2023 14:04:13 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D35F46AD
        for <live-patching@vger.kernel.org>; Mon,  8 May 2023 11:04:08 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-75783ac48e7so97067085a.0
        for <live-patching@vger.kernel.org>; Mon, 08 May 2023 11:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683569047; x=1686161047;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=430ps2sqnmyOG7CkocvHHgo7LY5uawW1HIr8oL2FOAI=;
        b=N3JiBoqtHOk8wtIE3COb3IiwwOK8XAMUrx0sWeYfu+ahh8Xell9rPu4v3dGGsU2CzY
         1/2HbObh5DxHin3YWYxsdpeBia5+QgEI5kH697o4fkwXVLRbyRjj4kV/NFdS7XIAwguW
         KMRu1kjT9OxfKUi/YkEWNPrHERgKCTaolmF5hFIcyWj2k8Bfwz8t96/Rtz5MQooKnVio
         aWm7DY4UKMFg7Yd58NHN4s+xtfI/glXLNTPDanDe0W9BIBplr5Pc90gSiMz9BZImkGW0
         pnBQZTcrjhQnz3xofZIMhGCMtHvT6AemUNYjVm2FI+7E41371c4dSfJO/YRJwlFRRorH
         UcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683569047; x=1686161047;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=430ps2sqnmyOG7CkocvHHgo7LY5uawW1HIr8oL2FOAI=;
        b=Jm/vYTOSfw/N8Xpp8+7J+uEL/Be6xDzJRc69XjRj+jVR1fulltQNHS6gwyERZgM9k9
         J7lHVuLAKw1vxjUFQcdtEpFe0x8RyHJ6dDDQ/luBG/CoGIrX6y62tsbwDaRulIro8p7a
         laCxknSQZbrHL0BsRTrzIU9SVXA2Oo7jiq1MJHkc9d55SdbBmwM3Y/nEMNgaZFjPyUND
         QtPzYWK7aOTjPQnnklbb63oRnHN9jiltd4lKtrPKaECG2lXae73MsA51P9DEw+3Cxexm
         /kP4tKxihZ6TWUt9lstrGZ4Nth8i+2Fs8mBTmwzekPwB4mNEB75y0mmmghMxpxtPO7g4
         NJFA==
X-Gm-Message-State: AC+VfDwRJ7QjV239Qh/62bmOBSLXczWtrA+2dOFwpu8cl0S4+GhC1dyd
        f0NxBYqydcGsDRerBG2oKfJJAtGp8zEvgKFIrOM=
X-Google-Smtp-Source: ACHHUZ6pRfTHSxRaPYwabQ2fSIzb/wXvmsVYMl+pggxM56X11uHDpgFlD7Nslp/4i6L0DUk7GbaObV6FgWlHw5PjB/U=
X-Received: by 2002:a05:6214:48b:b0:5ef:486a:505e with SMTP id
 pt11-20020a056214048b00b005ef486a505emr17286500qvb.41.1683569047353; Mon, 08
 May 2023 11:04:07 -0700 (PDT)
MIME-Version: 1.0
Sender: fredadiyo@gmail.com
Received: by 2002:a0c:db8a:0:b0:5f5:5adf:f93 with HTTP; Mon, 8 May 2023
 11:04:07 -0700 (PDT)
From:   Miss Marybeth <marybethmonson009@gmail.com>
Date:   Mon, 8 May 2023 18:04:07 +0000
X-Google-Sender-Auth: dYqR5Itgkyj9sIc5F0Bq7a1Gy2A
Message-ID: <CAAS6DFn=f9fhqcFJ7ekjp8P6w-PG32K9AoX+sHqfnF-fUwTSWA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hallo,

Sie haben meine vorherige Nachricht erhalten? Ich habe Sie schon
einmal kontaktiert, aber die Nachricht ist fehlgeschlagen, also habe
ich beschlossen, noch einmal zu schreiben. Bitte best=C3=A4tigen Sie, ob
Sie dies erhalten, damit ich fortfahren kann.

warte auf deine Antwort.

Gr=C3=BC=C3=9Fe,
Fr=C3=A4ulein Marybeth
