Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B52350D3F
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 05:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhDADox (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 31 Mar 2021 23:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhDADom (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 31 Mar 2021 23:44:42 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ED6C0613E6
        for <live-patching@vger.kernel.org>; Wed, 31 Mar 2021 20:44:41 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d13so737424lfg.7
        for <live-patching@vger.kernel.org>; Wed, 31 Mar 2021 20:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=Djm5RACG0Q/tTggkaTME8LERkF9KDASCXoX4HtuQQkI=;
        b=Ym2YqZMnSX00eU3I6Fow01pSOvJ34l7d9PaZ4Gg1Y1egbD46aq5iGAoKf1tdCO95D7
         itgvinf3kIhDB5yMuiir9VO29HHxoqxX9EowM55chgLnJSCaxBOsyJ7TSLtKrvGVvdaO
         /WFhgvmxUpB7v99WsyKAMbmaiyOJWLuWx+c6z2OPkVgkGakjVCypRQy3UVNgx4iVeelA
         qcJJxnABSWGYYhS8KeArbqosqMNIhCFvr4Ml94m70+Rm0MTO8C7401gdZNLexh4vWXW8
         YWw0IzCL9EA3851tVD0R3cBnVj0Ji212JVfaA93oIecwhQNGxZb6G1Gkf5Xe7FQTCbVd
         g8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=Djm5RACG0Q/tTggkaTME8LERkF9KDASCXoX4HtuQQkI=;
        b=iejv/+FrqR4Oq99GAj0ZOQ0hg17kHTR0eb2Ik5q6ydQM05SqPlAVLcCP5wGyGTjMon
         smyU2b9h3+n7mQYyflCyrsYsXp8e/5tQeLROF5aTBdYil3H5iX4ybGNevI5jyku2L0F6
         MN1QlKzJyMClePRDyUK6twUt9y7c1UAd0ZSAozBCATjBZ1Vx9H+WfLRGdhLJ4gksn8P+
         ooHjXLbGiTgWsXSwGAp0Np8FmhxccZTO4xWP+FR/qALoKyGpytjFGICIprPE7VY24NA3
         Skcv4EX6QIggVBRdXdoX7iIvoIFe/hUt5nQwZBAJFULF+FycnQPEoxrwLH8JBrOmhuuo
         nfLA==
X-Gm-Message-State: AOAM531SM3OZ+u/I3jjvjbUeyIjAX5fg2zR+MHRpzPX8P9L8Q6f3E3Ve
        hGxGmqc2v1pCjAAj0APOuCO+jeUPUHd78WqzvNQ=
X-Google-Smtp-Source: ABdhPJwAqWsOPuwwK9Q10y8AL5baP+WTdXZ9mdPKYb7QXelO5i5/paHC1nqe4FL/gyyKA/LDG7TMDc3oYFqWTsHdXUQ=
X-Received: by 2002:a19:2242:: with SMTP id i63mr3882426lfi.643.1617248679874;
 Wed, 31 Mar 2021 20:44:39 -0700 (PDT)
MIME-Version: 1.0
Sender: faridasalam3@gmail.com
Received: by 2002:ac2:5dd4:0:0:0:0:0 with HTTP; Wed, 31 Mar 2021 20:44:39
 -0700 (PDT)
From:   Nadia Richard <nadiarichard010@gmail.com>
Date:   Wed, 31 Mar 2021 20:44:39 -0700
X-Google-Sender-Auth: Ia8ioOKhKuAKuaiIyahNrk9yXzU
Message-ID: <CAGeoi-Hh_vuB9D785_zJ9L8M0Qy+hoKiYR+E4K-Y=KD4tP1EJg@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello how are you
