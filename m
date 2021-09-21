Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2061C412E54
	for <lists+live-patching@lfdr.de>; Tue, 21 Sep 2021 07:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhIUFx2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Sep 2021 01:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhIUFx1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Sep 2021 01:53:27 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C5C061574;
        Mon, 20 Sep 2021 22:51:59 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i4so77517366lfv.4;
        Mon, 20 Sep 2021 22:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xglXQZeaLjpmUmpIXkt4X5ZZq8DlETABa0SEfcACxlA=;
        b=c+as/OVscRWXx61L/O6SYawqHdzoWAXS7Y0w2FtvnkLeS/ZHScB2vkizB1M5VFFDAq
         7HXqay36117dURzYK4HWLmOXm2q/UluEazL6COee4yhPwBxo9m3kOHwgUPaNFWqbwmGj
         iK5kK385b/cUmijYPeVtShwwsdosOtpjpwSCrEEeII50ixgKzjH5mMZqq36/t+Ai0DS+
         nj4ucjrKKEOb8CbKKq6ul2tRpcIuUlna/PpdP911Irsz7vHWiJEow7n6SzIbYBlT9poq
         9UF8UAWaiTjQ8OHCQO/8T6t38Z/FYH/EkPeOq4w2mMXAcz6ZrflJu57wy+7cnMwY6uYO
         hpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xglXQZeaLjpmUmpIXkt4X5ZZq8DlETABa0SEfcACxlA=;
        b=mAJrv7ov4lNzBIt2odwlPyJWpv8xL75vcQsBBc659qI9lM8vR+0lSYITgWApTfBtS2
         NRf00skkyOPcGBsyTcx/dSGkEKi7PqnkwKPE3xypuHxXpw2H0iH3CwSyzwfQ5k9QrMhK
         IzXVyaoM/nwfWEifcPPFj0W8uhWVnveEAYiqugzH4Chs7p7uRdynX8GZZHsAjiKZsbFt
         FskOIa3xSwKUAVLv3CzijuQTFQ98xR4Zh5Xqy6AvX/KHEakN6ROJcgJdT+XGLm/p8xt0
         dfz3m0AkLkwofA6hY1pJmqxwrW7ZuLZrZF+BtHz3Nr+gyINZmskmXG9TaShOyJaJr1jC
         fbrA==
X-Gm-Message-State: AOAM532EFj0YPu6rNTuqM8OtiOvltu3NTLHgxCiTrVmh1CvwhsjJNcPD
        Ylb5VfKeqtZdt6A/hJcUVD83/ROtnRKXN9NRpvU=
X-Google-Smtp-Source: ABdhPJysH4yBw6yw+y5ndoNNQA5gYKSyFWwGu7s/LIkvT2rq1MRDbLNhjBvx/5Wz+PxgYrCZT/Jn6f8i+rk/PKI/gbk=
X-Received: by 2002:a05:6512:12c8:: with SMTP id p8mr6269890lfg.40.1632203518088;
 Mon, 20 Sep 2021 22:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210810051602.3067384-1-mcgrof@kernel.org> <YUIwKUXc7YbVAqut@bombadil.infradead.org>
In-Reply-To: <YUIwKUXc7YbVAqut@bombadil.infradead.org>
From:   Lucas De Marchi <lucas.de.marchi@gmail.com>
Date:   Mon, 20 Sep 2021 22:51:46 -0700
Message-ID: <CAKi4VAKbN31hqfg5EHZO=T_Hdkv3uhzarFLuEZO4b5Zm+TF77Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] kmod: add patient module removal support
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-modules <linux-modules@vger.kernel.org>,
        live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        Jessica Yu <jeyu@kernel.org>, osandov@fb.com,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 15, 2021 at 10:41 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> *Friendly poke*

Sorry for the delay. Let me take a look in detail tomorrow.

Lucas De Marchi


>
>   Luis
