Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0366473B51
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 04:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbhLNDNQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 22:13:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232655AbhLNDNQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 22:13:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639451595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/n9aD3d3fHxDG9Px4q5PGZku+eA71D79JAz4+k/9vSg=;
        b=KNX/7cw6yv4x7Y4/KR/QUzhtk6pUyft+0WhZlJOZlDff78X9Or9LnzDsX7oUyZRdKxa7ES
        TYppZy2464pTzKrT3aRHoTkwaaQFqEr5Uew/S24y94l/EOd+/TkwLIfmju8qmoFETt8ZKO
        Kla6MKkFRaEU/D8NVUm6e8qG7Bi/7F8=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-WBPljzMoM6iwc-GX5fVDxQ-1; Mon, 13 Dec 2021 22:13:14 -0500
X-MC-Unique: WBPljzMoM6iwc-GX5fVDxQ-1
Received: by mail-ot1-f71.google.com with SMTP id a18-20020a0568301dd200b0056328479effso7371608otj.3
        for <live-patching@vger.kernel.org>; Mon, 13 Dec 2021 19:13:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/n9aD3d3fHxDG9Px4q5PGZku+eA71D79JAz4+k/9vSg=;
        b=l967XsVD7ZGq1a2NXwlKqx+pnMfKZk9DU9hEunJ1ch6TooyvRBT6Zd1PLKXUVfsNq+
         Be7J9ID1XDBw+9e/0TZcm/C7uHqarPplBIINXslrwZsG1b7DqNHph41j/7/a+RedMv55
         fkx3wEkQmEEvr2GjYhODbhinfXPWTzJIt/ncFX0GGMJAeLGERciVtQ5m5a/8smTaUCCx
         4LJ5cm4OnEzao9z8VMOM7q2NuMimWYEhqVzsyOhblXXuGqAIqW04FFJSHBMGo35aawwZ
         c6w8dOWbs03sk7u9ZNWZcYFQIWC1cqctzSY28WgE6MsvQ0Y8Anjml6QMmHAfUr+irhES
         92JQ==
X-Gm-Message-State: AOAM532Mk4Hd4bbHipyzK5oDJtffw8w9623FmY0rlLB8giYjw+Wzs+1Q
        HckDVMXxbFZfVnHvmTIIXpZwtzl6EGy3W7aPu8gmvUXIl44tVslj3/SkyNenafvQF13KdxxHQqH
        K6krf3VXFPJ01atFntRKnvlMgSg==
X-Received: by 2002:a05:6830:195:: with SMTP id q21mr2069556ota.355.1639451594182;
        Mon, 13 Dec 2021 19:13:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx2iz3hCs6r9lH/lXETVLAPnC49R3ZFNXhsPRQSXrmKaougoXLA3UjZIBo5VrH12Mh87hPjNg==
X-Received: by 2002:a05:6830:195:: with SMTP id q21mr2069533ota.355.1639451593954;
        Mon, 13 Dec 2021 19:13:13 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::49])
        by smtp.gmail.com with ESMTPSA id 186sm2963571oig.28.2021.12.13.19.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 19:13:13 -0800 (PST)
Date:   Mon, 13 Dec 2021 19:13:10 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     David Vernet <void@manifault.com>
Cc:     pmladek@suse.com, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <20211214031310.p6kmbvd73kn6j7x3@treble>
References: <20211213191734.3238783-1-void@manifault.com>
 <20211213201022.dhalhtc2bpey55gh@treble>
 <YbfQHjoUO5GTvImR@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YbfQHjoUO5GTvImR@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Dec 13, 2021 at 02:58:38PM -0800, David Vernet wrote:
> > I don't think the fix will be quite that simple.  For example, if
> > klp_init_patch_early() fails, that means try_module_get() hasn't been
> > done, so klp_free_patch_finish() will wrongly do a module_put().
> 
> Ugh, good point and thank you for catching that. Another problem with the
> current patch is that we'll call kobject_put() on the patch even if we
> never call kobject_init on the patch due to patch->objs being NULL.
> 
> Perhaps we should pull try_module_get() and the NULL check for patch->objs
> out of klp_init_patch_early()? It feels a bit more intuitive to me if
> klp_init_patch_early() were only be responsible for initializing kobjects
> for the patch and its objects / funcs anyways.
> 
> Testing it locally seems to work fine. Let me know if this sounds
> reasonable to you, and I'll send out a v2 patch with the fixes to both the
> patch description, and logic.

Sounds reasonable to me.  Thanks.

-- 
Josh

