Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6208642DD0
	for <lists+live-patching@lfdr.de>; Mon,  5 Dec 2022 17:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiLEQvH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Dec 2022 11:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiLEQuS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Dec 2022 11:50:18 -0500
Received: from mail-oa1-x44.google.com (mail-oa1-x44.google.com [IPv6:2001:4860:4864:20::44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D602182D
        for <live-patching@vger.kernel.org>; Mon,  5 Dec 2022 08:49:19 -0800 (PST)
Received: by mail-oa1-x44.google.com with SMTP id 586e51a60fabf-143ffc8c2b2so14151115fac.2
        for <live-patching@vger.kernel.org>; Mon, 05 Dec 2022 08:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=JqPOhlxjav40zQ8KEP4KTU0OPx7Lt4PHyhZKP19nsc1s2nwKZSv5HlcijwyiSZs78H
         dkSTYYx8uEtxZcKLrVxEYSCdc2zovoDHNg1p+HhNY47MD4MIOSWNu07vX2rB+PgyJfKl
         zVc1Q/Ec75Tg7o4InQvqCPpaJSHjRgoeOF+ud7tOktSHhG/wDzQrY3AmjkXXMjRtw0s4
         hMC5kQFHJlkQbvIkBXkR4e3Uxyz2Feapkqgsz2WdnjibG1uC/BUlcvk+tPGCLlGbqNNH
         V0SxUnpHzIXg2rFlrLdSzhzsDv33teQm+nnA7c67P0CCLTTpWqd47C+ad+WJ4kg0474J
         /1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=ux83MSy5AYhOYk6mX/NBZ5GUBx13uv/MlC0KYb2xeqXRwyTRaga9oKVoWWiwOq8BPQ
         Grnr3zDLKj3Uo8WWd6dgZYQWr/SYuQR4BnikY4GLmzMivA4o1Ml0U74mySzyDjU4CIjZ
         Ks6lwxbJXV2qFYp9yUjHpMdEuoWVzHWz9NfdxuV+HsLCTKsr+QYzbjhZYdNS+fz5qxrR
         F6KnYZjl9z6Bz6ibYko3Wlm4DLL2UjZhUrRawyYRARXtpNgN1Baz6I7RWLTICaZWeCZY
         h6aOnR6wYBK3fAoJMh1YKMedCixMi9pluTx+rMNDzfdv+0sxXfoXglCC6iy2aUA1i5KC
         eZQg==
X-Gm-Message-State: ANoB5pmlgGzTK0wgmQYAwPWKBLXsmPCmXWIpfaBKO7U49wuX1nFK4PZ5
        sEkhkcAStisf7BwzmumAmMQs7cgJhDKodu6NrpS0MtSzjGe+kA==
X-Google-Smtp-Source: AA0mqf4emqsULQaWmlSvzix3i4WPOQ5LTbG2PI8kUo1Hf6UAHEw3W5fxwASTJvSySPdeDJOXsy5airQW+HaiYULiN7A=
X-Received: by 2002:a05:6870:c895:b0:13a:dd7e:7bda with SMTP id
 er21-20020a056870c89500b0013add7e7bdamr48365915oab.222.1670258958925; Mon, 05
 Dec 2022 08:49:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:7211:b0:dd:1fa2:ef73 with HTTP; Mon, 5 Dec 2022
 08:49:18 -0800 (PST)
Reply-To: plml47@hotmail.com
From:   Philip Manul <lometogo1999@gmail.com>
Date:   Mon, 5 Dec 2022 08:49:18 -0800
Message-ID: <CAFtqZGE4FPE5M8+dW=jfhZ3frvv81QiB1qFGpQtYDHEJN7gOzw@mail.gmail.com>
Subject: REP:
To:     in <in@proposal.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

--=20
Guten tag,
Mein Name ist Philip Manul. Ich bin von Beruf Rechtsanwalt. Ich habe
einen verstorbenen Kunden, der zuf=C3=A4llig denselben Namen mit Ihnen
teilt. Ich habe alle Papierdokumente in meinem Besitz. Ihr Verwandter,
mein verstorbener Kunde, hat hier in meinem Land einen nicht
beanspruchten Fonds zur=C3=BCckgelassen. Ich warte auf Ihre Antwort zum
Verfahren.
Philip Manul.
