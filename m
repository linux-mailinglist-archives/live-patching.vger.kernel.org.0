Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F134AB0C4
	for <lists+live-patching@lfdr.de>; Sun,  6 Feb 2022 17:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiBFQ5i (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 6 Feb 2022 11:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbiBFQ5i (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 6 Feb 2022 11:57:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF42FC043186
        for <live-patching@vger.kernel.org>; Sun,  6 Feb 2022 08:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644166655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nj8ZhaWyrNgsbixCTI1WPw5NYTJpZ/GvO+OBOf7Xfj8=;
        b=b5KRWbuKRP3SJDY7FrwIiv7cNaw3lMbfdeu+tMLFtF4XjzCe/UUC1Ra4iGluQHIVHEcJ/y
        zDWjRls8YYnit/dcp+4UiRTSCVoGIg49oBw3eu7+mcg34YNIUmfOF123855kLDru+o4isa
        xScOfcIcAGbP7B9hC9imrLeiZdyVwqk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-HtkJJJo0PW6UHcDZe8q9FA-1; Sun, 06 Feb 2022 11:57:34 -0500
X-MC-Unique: HtkJJJo0PW6UHcDZe8q9FA-1
Received: by mail-wm1-f72.google.com with SMTP id l20-20020a05600c1d1400b0035153bf34c3so10803758wms.2
        for <live-patching@vger.kernel.org>; Sun, 06 Feb 2022 08:57:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nj8ZhaWyrNgsbixCTI1WPw5NYTJpZ/GvO+OBOf7Xfj8=;
        b=EwnB5eOlMztZLkAGUVnn7CW4YJ8UIBCcBnhh6UVHS8/1ayHl/7JeYJdds00tNaP4WZ
         g2h+57ek1Dzm/XYdnd/1JQuxudxz3hHjqo/pGyyTRkhpqFQ1AevQ/MZPbfAp7MUgP5Wq
         dYB8QGFsS5vM2rvAcZyNOIkQ9QyMAAUhCGV/+oyyHToClx+0WzewVAVTCW9A3jKhcuEs
         k/U28RdgZEJxTMfGPg6jtDUHxkYpGWfaiY6pyEpr0Jo7faOxu++Yds1osBsSxfDLfNw6
         Z/oc7YoKKsSF8AB3ZNCHtlXI5wlfPhKqKUiCkjwNdzhV9pi+hklP3k4cM6GfxMZoyjGb
         5uig==
X-Gm-Message-State: AOAM532iw41GQv/fqQtj89d6VcYql1XRWE4k6sgIzQCOPbLp24Qw6HhF
        uKZkdNE+9fWtvG3wKjia0Ie/qgYzA51N7cvJZzqDPvMA5n0wm0BrpmTkQ3kXhRvTYb700FneZjc
        06mIrgbAlvw/lc8xXKTPg3sj9
X-Received: by 2002:adf:e196:: with SMTP id az22mr7022633wrb.113.1644166653406;
        Sun, 06 Feb 2022 08:57:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzX0n3HHySvpcKHUlPDvRzl6SK5emiCLQSwfdUs9Vi2BoUh+o91qWVC6WJC5r45HbYobbBtFA==
X-Received: by 2002:adf:e196:: with SMTP id az22mr7022607wrb.113.1644166653192;
        Sun, 06 Feb 2022 08:57:33 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id g20sm20634047wmq.9.2022.02.06.08.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 08:57:32 -0800 (PST)
Date:   Sun, 6 Feb 2022 16:57:32 +0000
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        "cl@linux.com" <cl@linux.com>,
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
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Message-ID: <20220206165732.fjge6teag2hf3cc4@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
 <be5db28e-ead0-4bed-d826-06ffba1e96f7@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <be5db28e-ead0-4bed-d826-06ffba1e96f7@csgroup.eu>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-03 18:15 +0000, Christophe Leroy wrote:
> I also have the feeling that a lot of stuff like function prototypes you 
> added in include/linux/module.h should instead go in 
> kernel/module/internal.h as they are not used outside of kernel/module/

Agreed - this will be reflected in v5.


Kind regards,

-- 
Aaron Tomlin

