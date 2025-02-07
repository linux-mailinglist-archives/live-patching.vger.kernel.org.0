Return-Path: <live-patching+bounces-1127-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B534AA2BF7C
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 10:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41B7E16461A
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 09:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D1A1DDC04;
	Fri,  7 Feb 2025 09:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QbW8aKkx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C81DDA31
	for <live-patching@vger.kernel.org>; Fri,  7 Feb 2025 09:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738920969; cv=none; b=FRH+Yf9Yan9kePNtDnocB72v2WVZFmJNZx8mhzbNxYCOXCllBwdj8MHFwXjFiknmCWuYvUDVn1xnrn2xg1COYwes+2U3WErMI5gNEeJN3dSdmHwWmVzTEemIA9gYNdjh/WHcTAAlA1+zANXgLZy+ovMkyek0SnIHt6qnJ7/nWf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738920969; c=relaxed/simple;
	bh=1NzutA7DJ1VwDjp8/CD7+1BalgjXyZf1dagvDXNqAPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJDeV+ktBc+s/kWTIkRYs/jPVT26/FYQFlpLsIW6420EB9beZSU1GFFhyXWNMUmOF51C4XxfWzG4MwQ8dp89+V3iVR+nVnb0yDAfhZ85+2lqAFSMqXs11j+wtaQFbdp12k65uusrQaKUS8P9zvpWeZhBi7qCUHtcYkF3QCJ6hus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QbW8aKkx; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-436341f575fso21247875e9.1
        for <live-patching@vger.kernel.org>; Fri, 07 Feb 2025 01:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738920966; x=1739525766; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x4X06Qs9UvWbwZNdxFJb+Yx4PivfRYmx4jvXug+bNSc=;
        b=QbW8aKkxCqk5dBrn5I2TAOCBtBrbfddxCoY0w7f1Q8bEP3VUJ9339ExE4aTWbS9z0U
         QpXOQ2ODJAu2N2KaXbDO6Ond53+u8WST1XPN2CAv+DZfyTDUkxVESZQYgzDKjNxVDmQW
         auxI5lyj4yJeHFrvy5FI9ZFE/+vI7FDnIWEKlf/MaoHgzFEGE9VQeb4sAuvkSooipD2H
         Wb7JB9DAHlMDx7T7JvAZIR4eE80uM03qtqdXt/QpQPYtQb5EZxjDoAzI+tx6yC8QiGcv
         9ZXuRGFHNNfe5xu2q06DiBhEELn87r4LxNvpnydEygo/NQ29JNqprd+Df2T6H9CZ0P8x
         oikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738920966; x=1739525766;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x4X06Qs9UvWbwZNdxFJb+Yx4PivfRYmx4jvXug+bNSc=;
        b=rYptL3+VrVC4oehPvSrHYYHJKsLe5FdRkORBCNQ1dkQpV//AEXvmKLocW8p6x3PG9R
         Jv+gJMofVqHczLV9jzVV/85Ikso1EfroEKBRD2IOUpD8AR6ioZC0leYR2v7IpPv2pYiv
         9kef1+rmsNnwRTem+7RBY+/7uVPJrLAb28LchOAg+Dj0qv3ucICBzhyS9E4oGIJbGMw7
         lBS5ROB8u3CwAam4Lh1sNTh5enFwel2n9V19uuJGG1scYQ0EpUxO+my88jHOgCcOmhru
         aQrddoj8wdlDwkBC/Za+VZhtErGI9MYi0QQVZDCtmHSyqGc3WXixoPuONCP2OtrB1Kfl
         PB8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWNioCfYFeiDLOvlinmZFx0jP+OV4h2IMzyJRxbM+Cqs54VbG63eiMGRpQbhwYJRB9M4DE/vQiXPq0H2fAo@vger.kernel.org
X-Gm-Message-State: AOJu0YyDSkNId0hEZFFpPewVUObBnitAc933QPKb+8cqwmtMtwWWkmS6
	9faLWw+FubkFIPpOYqBMSUHxnYOw1M1/KK14xvANfVOY4ILTfxUJSmHBNz2p0LI=
X-Gm-Gg: ASbGncuQmnJ6aKSqU2f9EocAIikjopV19d8zRM17unlPYbfLLiKU7DIy9w4C2cos+Mi
	A0y+vYME7Kl2biAreSMowVRs7xtpKW5YPyu5FFnR2d9ts56PVTOvtI1aGH0VYBOq4JzVSS5X5It
	BmNzcsFpFcULLV8YER4iaT/lvaLE1nMyrHxcc3oexJqTNm+C6IyP3iA1SguGVOUtDL0ousSoo7w
	ciGiqhUQZh9+im7klX92+KCqRm8eYomGb8y5kfPbP9o9v+BBizdCyFkf51EpEFShqNP7KeXtRjN
	6sS9C/1+rGOMlTTlAw==
X-Google-Smtp-Source: AGHT+IH17/7eHOlSl4vMAf78uUWL2wft34rlCJFu4fOsZi2jI5IZNntK9gohDx77x/ddwWEyQw9tYA==
X-Received: by 2002:a05:6000:1ac7:b0:38a:1ba4:d066 with SMTP id ffacd0b85a97d-38dc90f0e6fmr1849860f8f.27.1738920965911;
        Fri, 07 Feb 2025 01:36:05 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dbdd1af32sm4073697f8f.16.2025.02.07.01.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 01:36:05 -0800 (PST)
Date: Fri, 7 Feb 2025 10:36:03 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Message-ID: <Z6XUA7D0eU_YDMVp@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <20250127063526.76687-3-laoar.shao@gmail.com>
 <20250207023116.wx4i3n7ks3q2hfpu@jpoimboe>
 <CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com>

On Fri 2025-02-07 11:16:45, Yafang Shao wrote:
> On Fri, Feb 7, 2025 at 10:31 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > On Mon, Jan 27, 2025 at 02:35:26PM +0800, Yafang Shao wrote:
> > > - Temporary Loss of Patching
> > >
> > >   During the replacement process, the old patch is set to a NOP (no-operation)
> > >   before the new patch is fully applied. This creates a window where the
> > >   function temporarily reverts to its original, unpatched state. If the old
> > >   patch fixed a critical issue (e.g., one that prevented a system panic), the
> > >   system could become vulnerable to that issue during the transition.
> >
> > Are you saying that atomic replace is not atomic?  If so, this sounds
> > like another bug.
> 
> >From my understanding, there’s a window where the original function is
> not patched.

This is a misunderstanding.

> klp_enable_patch
> + klp_init_patch
>    + if (patch->replace)
>           klp_add_nops(patch);  <<<< set all old patches to nop

1. The "nop" entry is added into the _new_ (to-be-enabled) livepatch,
   see klp_add_nops(patch). The parameter is the _newly_ enabled patch.

2. The "nop" entries are added only for functions which are currently
   livepatched but they are not longer livepatched in the new
   livepatch, see:

static int klp_add_object_nops(struct klp_patch *patch,
			       struct klp_object *old_obj)
{
[...]
	klp_for_each_func(old_obj, old_func) {
		func = klp_find_func(obj, old_func);
		if (func)
			continue;	<------ Do not allocate nop
						when the fuction is
						implemeted in the new
						livepatch.

		func = klp_alloc_func_nop(old_func, obj);
		if (!func)
			return -ENOMEM;
	}

	return 0;
}


> + __klp_enable_patch
>    + klp_patch_object
>       + klp_patch_func
>          + ops = klp_find_ops(func->old_func);
>             + if (ops)
>                    // add the new patch to the func_stack list
>                    list_add_rcu(&func->stack_node, &ops->func_stack);
> 
> 
> klp_ftrace_handler
> + func = list_first_or_null_rcu(&ops->func_stack, struct klp_func

3. You omitted this important part of the code:

	if (unlikely(func->transition)) {
		patch_state = current->patch_state;
		if (patch_state == KLP_TRANSITION_UNPATCHED) {
			/*
---->			 * Use the previously patched version of the function.  
---->			 * If no previous patches exist, continue with the
---->			 * original function.
			 */
			func = list_entry_rcu(func->stack_node.next,
					      struct klp_func, stack_node);


	The condition "patch_state == KLP_TRANSITION_UNPATCHED" might
	be a bit misleading.

	The state "KLP_TRANSITION_UNPATCHED" means that it can't use
	the code from the "new" livepatch => it has to fallback
	to the previously used code => previous livepatch.


> + if (func->nop)
>        goto unlock;
> + ftrace_regs_set_instruction_pointer(fregs, (unsigned long)func->new_func);

> Before the new atomic replace patch is added to the func_stack list,
> the old patch is already set to nop.
      ^^^ 
     
     The nops are set in the _new_ patch for functions which will
     not longer get livepatched, see the commit e1452b607c48c642
     ("livepatch: Add atomic replace") for more details.
     
> If klp_ftrace_handler() is
> triggered at this point, it will effectively do nothing—in other
> words, it will execute the original function.
> I might be wrong.

Fortunately, you are wrong. This would be a serious violation of
the consistency model and livepatches modifying some semantic would
blow up systems.

Best Regards,
Petr

