Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A8E4BF685
	for <lists+live-patching@lfdr.de>; Tue, 22 Feb 2022 11:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiBVKso (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Feb 2022 05:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiBVKsm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Feb 2022 05:48:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91788D5556
        for <live-patching@vger.kernel.org>; Tue, 22 Feb 2022 02:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645526894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Brgp+fMdi1oCT47PODY2VNbqyXNOgHYpjuXrN5V3CFA=;
        b=ClOLj60VkZIwqDCCJv6UhRISrV23zuh22lq2GGjI/vjNT69wbM9sexQ+wRnb8Gkh3zTKfc
        FllHJEQIovJODCjd+ap8m4Nbe2JrmXGhwR3l0NK6tBVTOBfCy7jw0rhtdgSYyZGP9ADMvY
        mT+cz+MhLiOsWe2WNvWuCoLotbNYbbM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-m01S0O0XNMeDhJuyqEFCzw-1; Tue, 22 Feb 2022 05:48:13 -0500
X-MC-Unique: m01S0O0XNMeDhJuyqEFCzw-1
Received: by mail-lj1-f198.google.com with SMTP id v5-20020a2ea605000000b00246322afc8cso3671722ljp.4
        for <live-patching@vger.kernel.org>; Tue, 22 Feb 2022 02:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Brgp+fMdi1oCT47PODY2VNbqyXNOgHYpjuXrN5V3CFA=;
        b=q+7+P1lPaHGfQUyqWgaHWrLkz5hRtDsXjk5v3uARPyeYD3PTiNwg9p+7ZastHvI6S6
         BdW694xgg+pc/rbCtx+68x4IJYWn4g1N57qweBoIt+PDnQ3Ny1lAMFUJJLqYnb96VZ4I
         zsTqlmyJ6F5mrcDZJPzeETOZ+g70esu1KCyUwxZpnzc8Xiz15s813C2kpDNGbYRvaeDs
         NoL7emUXPmD65L2T7tAAv0NvaVn4agpgYoTi4o4Am0oVqKfvYEXI0G54y6lLXZjSNMOX
         9LDdg0pfUkc6B6VDlIlaKi7/Oj7Q+3y6pDnQ2hmJ+cfXscF6RMkIXd6hZs+dxRUi0TjA
         ypjg==
X-Gm-Message-State: AOAM532ZznLWAAolnbwtGXfkCcYXTINtLZWghNA7TBviHu3eLeARrLnH
        X5LfN+lCSmXc6w6s7MfTqeRdWBPmONzDzBFkI6iC13lAVbzj+Eyfx9vijUD6Qd3jzBJ9219RZDX
        3MSCwcWp4KIHHIgkHojyzX6BX6yJVDDDFcZjvDLCD
X-Received: by 2002:a05:651c:386:b0:244:e2ab:87f9 with SMTP id e6-20020a05651c038600b00244e2ab87f9mr16845175ljp.201.1645526891460;
        Tue, 22 Feb 2022 02:48:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyq/qtQrdadU6dXvqmqudQ/GJmIpBpSMhD58JRIHjIpHtPwrVmZjOlfNJRFUUCYYJk/WJ2CRWVA5ZqWdWAlVEI=
X-Received: by 2002:a05:651c:386:b0:244:e2ab:87f9 with SMTP id
 e6-20020a05651c038600b00244e2ab87f9mr16845165ljp.201.1645526891281; Tue, 22
 Feb 2022 02:48:11 -0800 (PST)
MIME-Version: 1.0
References: <20220218212511.887059-1-atomlin@redhat.com> <20220218212511.887059-2-atomlin@redhat.com>
 <69fcaad3-e48c-11ca-ed50-7a18831e3e91@csgroup.eu>
In-Reply-To: <69fcaad3-e48c-11ca-ed50-7a18831e3e91@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Tue, 22 Feb 2022 10:48:00 +0000
Message-ID: <CANfR36js06qG8HkQBPPz8bnYzcBRUtiZJAqhynt4XJcfcFXAQg@mail.gmail.com>
Subject: Re: [PATCH v6 01/13] module: Move all into module/
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Cc:     "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-02-21 12:21 +0000, Christophe Leroy wrote:
>
>
> Le 18/02/2022 =C3=A0 22:24, Aaron Tomlin a =C3=A9crit :
> > No functional changes.
> >
> > This patch moves all module related code into a separate directory,
> > modifies each file name and creates a new Makefile. Note: this effort
> > is in preparation to refactor core module code.
> >
> > Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> > ---
> >   MAINTAINERS                                         | 2 +-
> >   kernel/Makefile                                     | 5 +----
> >   kernel/module/Makefile                              | 9 +++++++++
> >   kernel/{module_decompress.c =3D> module/decompress.c} | 2 +-
> >   kernel/{module-internal.h =3D> module/internal.h}     | 0
> >   kernel/{module.c =3D> module/main.c}                  | 2 +-
> >   kernel/{module_signature.c =3D> module/signature.c}   | 0
> >   kernel/{module_signing.c =3D> module/signing.c}       | 2 +-
> >   8 files changed, 14 insertions(+), 8 deletions(-)
> >   create mode 100644 kernel/module/Makefile
> >   rename kernel/{module_decompress.c =3D> module/decompress.c} (99%)
> >   rename kernel/{module-internal.h =3D> module/internal.h} (100%)
> >   rename kernel/{module.c =3D> module/main.c} (99%)
> >   rename kernel/{module_signature.c =3D> module/signature.c} (100%)
> >   rename kernel/{module_signing.c =3D> module/signing.c} (97%)
> >
>
> I'm wondering whether we should avoid moving module_signature.c and
> leave it in kernel/ as this file is used even when CONFIG_MODULES is not
> selected, and he is the only one like this.
>
> Keeping it outside of kernel/module/ would allow to conditionaly build
> entire kernel/module/ based of CONFIG_MODULES and then avoid all checks
> against CONFIG_MODULES which look misleading at times.

Luis,

What is your opinion on this? Indeed, mod_check_sig() is used by code
outside of kernel/module/ too i.e. ima_read_modsig(); albeit, I believe it
does make sense to keep it under kernel/module/ since the function in
question is used to review a given module's signature anyway.

Kind regards,

--=20
Aaron Tomlin

