Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB02476101
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 19:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343945AbhLOSrO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 13:47:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343940AbhLOSrN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 13:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639594032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lKY7EwD35q6WS2L2MqJxnfYmiBbs4WYU4qRfF0IbNkc=;
        b=LRFOkhv07aLHubBkRkLDB+9e+nZuqScHtCtYDce5duAqoqk8qY5xLR3+K/3hJIDzlThTjE
        +ujxT4RazRjdrPdiu79n/q74xh0tl49C+sbnL8MnRfBlFvA/t8hbmHHJV7jPFo4ozVuE3w
        tCRpE9/P3u+7bfTeAAZbutpnQOoCZIw=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-I5hggEmMNYaYBxwrzkrh6w-1; Wed, 15 Dec 2021 13:47:11 -0500
X-MC-Unique: I5hggEmMNYaYBxwrzkrh6w-1
Received: by mail-oo1-f70.google.com with SMTP id j11-20020a056820022b00b002c6b134233fso15242480oob.6
        for <live-patching@vger.kernel.org>; Wed, 15 Dec 2021 10:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lKY7EwD35q6WS2L2MqJxnfYmiBbs4WYU4qRfF0IbNkc=;
        b=KNr2mUvhhUrRqSd2LXC2Kd34dv8C96pQGUMrhc21zxGgr0Apr//PnEMtG8unNyIVcv
         bhrW93fv5AuWt23QFOefjjhZW9L6QeDG6p7BmZcpzAvihAyM2HRJ1JjspGSCRDRX3Jj+
         TaiECyNwcobzxYvw90jkz3d/pogywPIjCaWr4IGGmkzrGg84wylLNI+tmRahmyGWnnmY
         /DJZbi5H1O+0Bsc8arRdMhlK9qR2Gsg5FSGq+/op/CmhmWJFQFQMW1T7lffel48d/aqT
         QReMLqMAeIdWlsRFXPOK20Aw0v/BJP9FkNKyYvH4BLVIjA83xk6Z8jjMyq4I3wq7cIKL
         pHFg==
X-Gm-Message-State: AOAM530VVFT20S2MIIhP+c8lymZoqVTRZIY6s7kD9CSKr6goSC/agARO
        4ry9TL+fmv87cYLk+25UTA8Jdghp5kdTz8t3aNCpIFbe4CbwNqRj+8pVGMynn19pcowEceENxcz
        mh3FFLqm8aMZvD7sYee9gQgiOlA==
X-Received: by 2002:a05:6830:442a:: with SMTP id q42mr9979376otv.385.1639594030934;
        Wed, 15 Dec 2021 10:47:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7tdoVycqReg+zBeRcXonNSCNGRuHqvtLWZQ7ha4DQnH/9nu6QOECMTd84iAOMu7T+0jBsgg==
X-Received: by 2002:a05:6830:442a:: with SMTP id q42mr9979356otv.385.1639594030598;
        Wed, 15 Dec 2021 10:47:10 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::49])
        by smtp.gmail.com with ESMTPSA id l6sm565290otu.12.2021.12.15.10.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 10:47:10 -0800 (PST)
Date:   Wed, 15 Dec 2021 10:47:07 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        joe.lawrence@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Allow user to specify functions to
 search for on a stack
Message-ID: <20211215184707.e3iagidkvnpx2fb4@treble>
References: <20211210124449.21537-1-mbenes@suse.cz>
 <20211210124449.21537-2-mbenes@suse.cz>
 <20211213190008.r4rjeytfz5ycbstb@treble>
 <alpine.LSU.2.21.2112140857570.20187@pobox.suse.cz>
 <YbiNsVfoCPCJmOKj@alley>
 <Ybi6252hKwUM4KrP@alley>
 <20211214234836.3x3clp45ut6gtol6@treble>
 <Ybn9piT9Z83SKaCK@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ybn9piT9Z83SKaCK@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Dec 15, 2021 at 03:37:26PM +0100, Petr Mladek wrote:
> > Hm, this is different than how I understand it.
> > 
> > In the past I referred to the "parent" as the function which jumps to
> > the cold ("child") function.  So maybe we're getting confused by
> > different terminology.  But here I'll go with the naming from your
> > example.
> 
> I think that I was primary confused by the selftest where "child"
> function is livepatched and "parent" is defined as stack_only.

Ah, I guess I didn't look too closely at the selftest.

> Miroslav told me yesterday that the function that jumps into
> the .cold child needs to get livepatched. It makes sense
> because .cold child does not have well defined functionality.
> It depends on the compiler what code is put there.
> Hence I added one more level...
> 
> > If parent_func() is stack_only, that could create some false positive
> > scenarios where patching stalls unnecessarily.
> 
> Yes, it won't be optimal.
> 
> 
> > Also, wouldn't all of child_func()'s callers have to be made
> > stack_only?
> 
> Well, we already do this when handling compiler optimizations,
> for example, inlining.
> 
> 
> > How would you definitively find all the callers?
> 
> Good question. The best solution would be to get support from
> the compiler like we already get for another optimizations.
> 
> We always have these problems how to find functions that need
> special handling for livepatching.

But inlining and isra are inherently different from this.  They affect
static functions, which the compiler knows all the callers and is free
to (and does) tweak the ABI.  The compiler (and the patch author)
definitively know all the callers.

If child_func() happens to be a global function, it could be called from
anywhere.  Even from another klp_object.  If there are a lot of callers
across the kernel, there would be a proliferation of corresponding
stack_only funcs.

It could also be called from a function pointer, which levels up the
difficulty.

> > Instead I was thinking child_func.cold() should be stack_only.
> > 
> > e.g.:
> > 
> > static struct klp_func funcs[] = {
> > 	{
> > 		.old_name = "child_func",
> > 		.new_func = livepatch_child_func,
> > 	},
> > 	{
> > 		.old_name = "child_func.cold",
> > 		.new_name = "livepatch_child_func.cold",
> > 		.stack_only = true,
> > 	},
> > 
> > Any reason why that wouldn't work?
> 
> Yes, it should work in the given example. I am just curious how this
> would work in practice:
> 
> 
>   1. The compiler might optimize the new code another way and there
>      need not be 1:1 relation.
>
>      We might need another set of stack_only functions checked when
>      the livepatch is enabled. And another set of functions checked
>      when the livepatch gets disabled.

Regardless I'm thinking the above approach should be flexible enough.

If the patched child_func no longer has .cold, set 'new_name' to NULL in
the stack_only entry.

If the original child_func doesn't have .cold, but patched child_func
does, set 'old_name' to NULL in the stack_only entry.

If there were ever more than one of such "sub-functions" (which I
believe currently doesn't happen), the author could create multiple
stack_only entries.

>   2. The names of "child_func.cold" functions are generated by
>      the compiler. I mean that the names are "strange" ;-)
> 
>      It is likely easier with the kPatch approach that creates glue
>      around already compiled symbols. It is more tricky when preparing
>      the livepatch from sources. Well, it is doable.

kpatch-build has checks for symbols with ".cold" substring.  I'm
thinking it would be easy enough for you to do something similar since
you're already checking for other compiler optimizations.

> BTW: livepatch_child_func.cold function must be checked on the stack
>      also when the livepatch is replaced by another livepatch.
> 
>      I mean that we need to check two sets of stack only functions
>      when replacing one livepatch with another one:
> 
> 	+ "new_name" functions from to-be-replaced livepatch (like when disabling)
> 	+ "old_name" functions from new livepatch (like when enabling)

Urgh, this is starting to give me a headache.

Could we put the cold funcs in a klp_ops func_stack to make this work
automatically?

Alternatively we could link the .cold functions to their non-cold
counterparts somehow.  So when checking a function's stack, also check
it's linked counterpart.  It could even be part of the original
function's klp_func struct somehow, rather than having a dedicated
klp_func struct for the stack_only thing.

Or we could just give up trying to abstract this entirely, and go back
to Peter's suggestion to just always look for a ".cold" version of every
function in klp_check_stack_func() :-)

I dunno...

> Note that I do not have any strong opinion about any approach at the
> moment. I primary want to be sure that I understand the problem correctly :-)

Same here.

-- 
Josh

