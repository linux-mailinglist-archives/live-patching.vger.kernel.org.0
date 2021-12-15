Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88CD4755C9
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 11:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhLOKGR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 05:06:17 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:35586 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbhLOKGQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 05:06:16 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 978751F386;
        Wed, 15 Dec 2021 10:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639562775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vm2YHP/8GRMx4aVfF6X4lnS6++O0zV4aNhqKbnyepCY=;
        b=sagjvOCJBkI8nqRXh5XXBCvVK8+hpaF9iVapfILC4M8Zn2Zjab5OS1hh/M9ElzCfPmHpen
        63FLcUEDMMv1wjyHD+uYvmeim4xU9gVGLHyDXwhcheDSfFbimHTINxgyJ4wPJeiM6wdtGO
        Y2MS/OcC4/BuAEYs0FMQZ1xsdnHaKdc=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5DCF4A3B81;
        Wed, 15 Dec 2021 10:06:15 +0000 (UTC)
Date:   Wed, 15 Dec 2021 11:06:15 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, songliubraving@fb.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] livepatch: Fix leak on klp_init_patch_early failure
 path
Message-ID: <Ybm+FyhLnuH4JThq@alley>
References: <20211214220124.2911264-1-void@manifault.com>
 <20211214235128.ckaozqsvcr6iqcnu@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214235128.ckaozqsvcr6iqcnu@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-12-14 15:51:28, Josh Poimboeuf wrote:
> On Tue, Dec 14, 2021 at 02:01:26PM -0800, David Vernet wrote:
> > When enabling a klp patch with klp_enable_patch(), klp_init_patch_early()
> > is invoked to initialize the kobjects for the patch itself, as well as the
> > 'struct klp_object' and 'struct klp_func' objects that comprise it.
> > However, there are some error paths in klp_enable_patch() where some
> > kobjects may have been initialized with kobject_init(), but an error code
> > is still returned due to e.g. a 'struct klp_object' having a NULL funcs
> > pointer.
> > 
> > In these paths, the kobject of the 'struct klp_patch' may be leaked, along
> > with one or more of its objects and their functions, as kobject_put() is
> > not invoked on the cleanup path if klp_init_patch_early() returns an error
> > code.
> > 
> > For example, if an object entry such as the following were added to the
> > sample livepatch module's klp patch, it would cause the vmlinux klp_object,
> > and its klp_func which updates 'cmdline_proc_show', to be leaked:
> > 
> > static struct klp_object objs[] = {
> > 	{
> > 		/* name being NULL means vmlinux */
> > 		.funcs = funcs,
> > 	},
> > 	{
> > 		.name = "kvm",
> > 		/* NULL funcs -- would cause leak */

I see in the subject and the commit message:

   "Fix leak"
   "may be leaked"
   "to be leaked"
   "would cause leak"

But the discussion suggests that nobody sees any real leak. I would
like to make this clear in the commit message.

Well, I still believe that this is just a cargo cult. And I would prefer
to finish the discussion about it, first, see
https://lore.kernel.org/all/YbmlL0ZyfSuek9OB@alley/


> Though, klp_init_patch_early() still has a failure mode which looks a
> little sketchy:
> 
> 	klp_for_each_object_static(patch, obj) {
> 		if (!obj->funcs)
> 			return -EINVAL;
> 
> 		klp_init_object_early(patch, obj);
> 
> 		klp_for_each_func_static(obj, func) {
> 			klp_init_func_early(obj, func);

Note that klp_init_*_early() functions iterate through the arrays
using klp_for_each_*_static. While klp_free_*() functions iterate
via the lists using klp_for_each_*_safe().

> 		}
> 	}
> 
> 
> While I don't see any actual leaks associated with it, it'd be cleaner
> and more robust to move the per-object !obj->funcs check to the top of
> klp_enable_patch(), with the other EINVAL checks.  Like:
> 
> 
> int klp_enable_patch(struct klp_patch *patch)
> {
> 	struct klp_object *obj;
> 	int ret;
> 
> 	if (!patch || !patch->mod || !patch->objs)
> 		return -EINVAL;
> 
> 	klp_for_each_object_static(patch, obj) {
> 		if (!obj->funcs)
> 			return -EINVAL;
> 	}

We should not need the pre-early-init check when the lists include only
structures with initialized kobjects.

Otherwise, I like the idea to do module_get() before
klp_init_patch_early(). I was never happy with the "hidden"
side effect.

I am also fine with calling klp_free() when the early init fails
if we agreed that it is a good practice. I just do want to pretend
that it fixes a leak what nobody sees any leak.

Please, wait few days until the discussion finishes before sending v3.

Best Regards,
Petr
