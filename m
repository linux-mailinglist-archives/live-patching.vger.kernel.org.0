Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0164474667
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 16:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhLNP0g (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 10:26:36 -0500
Received: from mail-qt1-f169.google.com ([209.85.160.169]:36496 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhLNP0g (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 10:26:36 -0500
Received: by mail-qt1-f169.google.com with SMTP id t11so18672589qtw.3;
        Tue, 14 Dec 2021 07:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P7aZ/QVBkU5v1FDVL+MSPCG24CP265jMOYd4Lci7QAM=;
        b=XuunziqYaqWgDfWdunecVEay59VyLZXN/DHsPa8K5nbcDEWD/DxyCcEJb4ypgRV7o4
         huRr5RYquc9SQfo40wagHGnUt8ubh4wiJpVpDc9TWAccDFme4bvg7KkpPpuYpT+XlAiX
         UmiabCpSR+tUCRJIey8z7x9oqOGaAWFJpvYUhmo1jfAplcETGLJFpyOW2O6KaJhZAZtb
         a8mXz5II2bOFoOMIuKX/+asxiL5G09J7KXv55QEGorFIEJ4vda5JvRkC6HCoBpj8f8zI
         PHz0w5L8R/UHv7aH0xTejgpFHTCKNQPsZu+ksgR6ABNGxHshqrYgOV9tmX2bCMXnub/Z
         pw5w==
X-Gm-Message-State: AOAM5307rDyrtM4FyDzWVxo0t+SKc+Ylk/8hBSPdT/pqQGcLQa8sgDgh
        nyoqdIljFNkJld7CgWw/vMY=
X-Google-Smtp-Source: ABdhPJwtxMV+qPxoSPw/frv+IfoiNQBShz4gj3PDxLQzfGgco5KthFLzi+AcceH5AM9DHu/FHoXxQQ==
X-Received: by 2002:ac8:7d89:: with SMTP id c9mr6719039qtd.74.1639495595519;
        Tue, 14 Dec 2021 07:26:35 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-026.fbsv.net. [2a03:2880:20ff:1a::face:b00c])
        by smtp.gmail.com with ESMTPSA id w10sm90823qkp.121.2021.12.14.07.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 07:26:35 -0800 (PST)
Date:   Tue, 14 Dec 2021 07:26:33 -0800
From:   David Vernet <void@manifault.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Miroslav Benes <mbenes@suse.cz> wrote on Tue [2021-Dec-14 10:17:08 +0100]:
> It would help to share warning outputs (or whatever) from DEBUG_KOBJECTS.

This is the output when running kpatch load livepatch-sample.ko if an extra
'struct klp_obj' entry is added that has a name but no funcs:

Without patch:

[   67.285762] livepatch_sample: tainting kernel with TAINT_LIVEPATCH
[   67.286107] kobject: 'livepatch_sample' (00000000cf89f7b6): kobject_add_internal: parent: 'module', set: 'module'
[   67.286113] kobject: 'holders' (00000000858b03bf): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
[   67.286126] kobject: 'notes' (00000000f2a3a4ce): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
[   67.297856] kobject: 'holders' (00000000858b03bf): kobject_cleanup, parent 00000000cf89f7b6
[   67.297859] kobject: 'holders' (00000000858b03bf): auto cleanup kobject_del
[   67.297861] kobject: 'holders' (00000000858b03bf): calling ktype release
[   67.297862] kobject: (00000000858b03bf): dynamic_kobj_release
[   67.297863] kobject: 'holders': free name
[   67.297865] kobject: 'notes' (00000000f2a3a4ce): kobject_cleanup, parent 00000000cf89f7b6
[   67.297866] kobject: 'notes' (00000000f2a3a4ce): auto cleanup kobject_del
[   67.297867] kobject: 'notes' (00000000f2a3a4ce): calling ktype release
[   67.297868] kobject: (00000000f2a3a4ce): dynamic_kobj_release
[   67.297869] kobject: 'notes': free name
[   67.297874] kobject: 'livepatch_sample' (00000000cf89f7b6): kobject_cleanup, parent 000000002555fa2d
[   67.297876] kobject: 'livepatch_sample' (00000000cf89f7b6): auto cleanup kobject_del
[   67.297877] kobject: 'livepatch_sample' (00000000cf89f7b6): calling ktype release
[   67.297878] kobject: 'livepatch_sample': free name
[   99.445938] kobject: '0:40' (000000002a98d11d): kobject_add_internal: parent: 'bdi', set: 'devices'
[   99.445954] kobject: '0:40' (000000002a98d11d): kobject_uevent_env
[   99.445957] kobject: '0:40' (000000002a98d11d): fill_kobj_path: path = '/devices/virtual/bdi/0:40'

With patch:

[  162.275251] livepatch_sample: tainting kernel with TAINT_LIVEPATCH
[  162.275985] kobject: 'livepatch_sample' (00000000e688ee30): kobject_add_internal: parent: 'module', set: 'module'
[  162.275993] kobject: 'holders' (000000004eee7860): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
[  162.276010] kobject: 'notes' (00000000c4f390ab): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
[  162.276028] kobject: '(null)' (000000003acccf72): kobject_cleanup, parent 0000000000000000
[  162.276031] kobject: '(null)' (000000003acccf72): calling ktype release
[  162.276033] kobject: '(null)' (00000000aeae6326): kobject_cleanup, parent 0000000000000000
[  162.276035] kobject: '(null)' (00000000aeae6326): calling ktype release
[  162.276037] kobject: '(null)' (0000000093b68297): kobject_cleanup, parent 0000000000000000
[  162.276039] kobject: '(null)' (0000000093b68297): calling ktype release
[  162.294063] kobject: 'holders' (000000004eee7860): kobject_cleanup, parent 00000000e688ee30
[  162.294070] kobject: 'holders' (000000004eee7860): auto cleanup kobject_del
[  162.294074] kobject: 'holders' (000000004eee7860): calling ktype release
[  162.294078] kobject: (000000004eee7860): dynamic_kobj_release
[  162.294081] kobject: 'holders': free name
[  162.294086] kobject: 'notes' (00000000c4f390ab): kobject_cleanup, parent 00000000e688ee30
[  162.294090] kobject: 'notes' (00000000c4f390ab): auto cleanup kobject_del
[  162.294094] kobject: 'notes' (00000000c4f390ab): calling ktype release
[  162.294097] kobject: (00000000c4f390ab): dynamic_kobj_release
[  162.294100] kobject: 'notes': free name
[  162.294114] kobject: 'livepatch_sample' (00000000e688ee30): kobject_cleanup, parent 00000000f9317c72
[  162.294118] kobject: 'livepatch_sample' (00000000e688ee30): auto cleanup kobject_del
[  162.294123] kobject: 'livepatch_sample' (00000000e688ee30): calling ktype release
[  162.294126] kobject: 'livepatch_sample': free name

The extra lines are of course the kobject: '(null)' entries, for which we
*don't* see auto cleanup kobject_del being called. So it seems that what's
there now is probably not actually leaking memory, and the question is
really whether or not the documentation in kobject.c is the source of truth
(i.e. whether the code needs to be "fixed" to honor the API contract).

> I think that this might be, once again, a false positive. We use kobjects 
> differently than what the kobject implementation and its documentation 
> assume.

I'm curious to hear what Greg says. As Petr pointed out, it seems that the
documentation for kobjects is inconsistent. If we're going by the function
comment header in kobject.c then what we have now should probably be
considered a bug? If we're going by what's in
Documentation/core-api/kobject.rst, I think what we have now is correct.

I do think it's a bit of a leaky abstraction to assume that the
implementation doesn't allocate anything, but I also see Petr's point that
it could be useful to make it explicit that kobject_init() doesn't allocate
anything, and instead just affords callers the option of using
kobject_put() if they want to the objects' destructors to be invoked.

Either way, we should fix the documentation to be consistent, which I'm
happy to do in another patch.

> And if it is not a false positive, we should implement some rollback for 
> processed klp_funcs and klp_objects if an error happens. It is not only 
> klp_patch kobject affected.

The patch (though it needs to be corrected in its current form, as Josh
pointed out) does already address this for the klp_funcs and klp_objects.
The 'err' label invokes klp_free_patch_start(), which eventually invokes
__klp_free_objects(), which itself invokes __klp_free_funcs().

Regards,
David
