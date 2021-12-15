Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37A947544E
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 09:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhLOIdY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 03:33:24 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59698 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbhLOIdY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 03:33:24 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C4479212C4;
        Wed, 15 Dec 2021 08:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639557202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SE5kKAwJJbJeUA+q0dVtGQ04SbKFFbZn6wkUr6Otfro=;
        b=bS3CHQGCk8NRc0KlaGPccKfm1nQY70PGq53nhwSpDngW16qv/8/WyQGr7Js/yxWdLXo34W
        fIOmxhbPnm/FHSaev16Sk8JWUWvbljsuiijI6fjuOdv+TJuBoOT3umEOVd9vKYaYyLqRjy
        kuZo03r4ciujY/5+DafuKQLHNywRCVI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639557202;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SE5kKAwJJbJeUA+q0dVtGQ04SbKFFbZn6wkUr6Otfro=;
        b=5c1y8Cscx6c8Zupa9AVg7iiJqcZmePx2Vmv2cT186idOCmIorgQ2upxgxnL9yUKSAJppgh
        PD4WOs4+RDEBVsCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 855DBA3B81;
        Wed, 15 Dec 2021 08:33:22 +0000 (UTC)
Date:   Wed, 15 Dec 2021 09:33:22 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     David Vernet <void@manifault.com>
cc:     Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure
 path
In-Reply-To: <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
Message-ID: <alpine.LSU.2.21.2112150929020.29089@pobox.suse.cz>
References: <20211213191734.3238783-1-void@manifault.com> <YbhZwVocHDX9ZBAc@alley> <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz> <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 14 Dec 2021, David Vernet wrote:

> Miroslav Benes <mbenes@suse.cz> wrote on Tue [2021-Dec-14 10:17:08 +0100]:
> > It would help to share warning outputs (or whatever) from DEBUG_KOBJECTS.
> 
> This is the output when running kpatch load livepatch-sample.ko if an extra
> 'struct klp_obj' entry is added that has a name but no funcs:
> 
> Without patch:
> 
> [   67.285762] livepatch_sample: tainting kernel with TAINT_LIVEPATCH
> [   67.286107] kobject: 'livepatch_sample' (00000000cf89f7b6): kobject_add_internal: parent: 'module', set: 'module'
> [   67.286113] kobject: 'holders' (00000000858b03bf): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
> [   67.286126] kobject: 'notes' (00000000f2a3a4ce): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
> [   67.297856] kobject: 'holders' (00000000858b03bf): kobject_cleanup, parent 00000000cf89f7b6
> [   67.297859] kobject: 'holders' (00000000858b03bf): auto cleanup kobject_del
> [   67.297861] kobject: 'holders' (00000000858b03bf): calling ktype release
> [   67.297862] kobject: (00000000858b03bf): dynamic_kobj_release
> [   67.297863] kobject: 'holders': free name
> [   67.297865] kobject: 'notes' (00000000f2a3a4ce): kobject_cleanup, parent 00000000cf89f7b6
> [   67.297866] kobject: 'notes' (00000000f2a3a4ce): auto cleanup kobject_del
> [   67.297867] kobject: 'notes' (00000000f2a3a4ce): calling ktype release
> [   67.297868] kobject: (00000000f2a3a4ce): dynamic_kobj_release
> [   67.297869] kobject: 'notes': free name
> [   67.297874] kobject: 'livepatch_sample' (00000000cf89f7b6): kobject_cleanup, parent 000000002555fa2d
> [   67.297876] kobject: 'livepatch_sample' (00000000cf89f7b6): auto cleanup kobject_del
> [   67.297877] kobject: 'livepatch_sample' (00000000cf89f7b6): calling ktype release
> [   67.297878] kobject: 'livepatch_sample': free name
> [   99.445938] kobject: '0:40' (000000002a98d11d): kobject_add_internal: parent: 'bdi', set: 'devices'
> [   99.445954] kobject: '0:40' (000000002a98d11d): kobject_uevent_env
> [   99.445957] kobject: '0:40' (000000002a98d11d): fill_kobj_path: path = '/devices/virtual/bdi/0:40'
> 
> With patch:
> 
> [  162.275251] livepatch_sample: tainting kernel with TAINT_LIVEPATCH
> [  162.275985] kobject: 'livepatch_sample' (00000000e688ee30): kobject_add_internal: parent: 'module', set: 'module'
> [  162.275993] kobject: 'holders' (000000004eee7860): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
> [  162.276010] kobject: 'notes' (00000000c4f390ab): kobject_add_internal: parent: 'livepatch_sample', set: '<NULL>'
> [  162.276028] kobject: '(null)' (000000003acccf72): kobject_cleanup, parent 0000000000000000
> [  162.276031] kobject: '(null)' (000000003acccf72): calling ktype release
> [  162.276033] kobject: '(null)' (00000000aeae6326): kobject_cleanup, parent 0000000000000000
> [  162.276035] kobject: '(null)' (00000000aeae6326): calling ktype release
> [  162.276037] kobject: '(null)' (0000000093b68297): kobject_cleanup, parent 0000000000000000
> [  162.276039] kobject: '(null)' (0000000093b68297): calling ktype release
> [  162.294063] kobject: 'holders' (000000004eee7860): kobject_cleanup, parent 00000000e688ee30
> [  162.294070] kobject: 'holders' (000000004eee7860): auto cleanup kobject_del
> [  162.294074] kobject: 'holders' (000000004eee7860): calling ktype release
> [  162.294078] kobject: (000000004eee7860): dynamic_kobj_release
> [  162.294081] kobject: 'holders': free name
> [  162.294086] kobject: 'notes' (00000000c4f390ab): kobject_cleanup, parent 00000000e688ee30
> [  162.294090] kobject: 'notes' (00000000c4f390ab): auto cleanup kobject_del
> [  162.294094] kobject: 'notes' (00000000c4f390ab): calling ktype release
> [  162.294097] kobject: (00000000c4f390ab): dynamic_kobj_release
> [  162.294100] kobject: 'notes': free name
> [  162.294114] kobject: 'livepatch_sample' (00000000e688ee30): kobject_cleanup, parent 00000000f9317c72
> [  162.294118] kobject: 'livepatch_sample' (00000000e688ee30): auto cleanup kobject_del
> [  162.294123] kobject: 'livepatch_sample' (00000000e688ee30): calling ktype release
> [  162.294126] kobject: 'livepatch_sample': free name
> 
> The extra lines are of course the kobject: '(null)' entries, for which we
> *don't* see auto cleanup kobject_del being called. So it seems that what's
> there now is probably not actually leaking memory, and the question is
> really whether or not the documentation in kobject.c is the source of truth
> (i.e. whether the code needs to be "fixed" to honor the API contract).

Indeed.
 
[...]

> > And if it is not a false positive, we should implement some rollback for 
> > processed klp_funcs and klp_objects if an error happens. It is not only 
> > klp_patch kobject affected.
> 
> The patch (though it needs to be corrected in its current form, as Josh
> pointed out) does already address this for the klp_funcs and klp_objects.
> The 'err' label invokes klp_free_patch_start(), which eventually invokes
> __klp_free_objects(), which itself invokes __klp_free_funcs().

I was just thinking out loud whether it would make sense in the 
_init_early stage to actually clean up (call kobject_put()) immediately, 
but you are right that the code in klp_enable_patch() and elsewhere is 
already prepared for that and it would not make sense to change the 
approach just because.

Thanks
Miroslav
