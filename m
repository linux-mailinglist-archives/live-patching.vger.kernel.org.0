Return-Path: <live-patching+bounces-394-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B98931D44
	for <lists+live-patching@lfdr.de>; Tue, 16 Jul 2024 00:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1146B282C21
	for <lists+live-patching@lfdr.de>; Mon, 15 Jul 2024 22:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D238313C816;
	Mon, 15 Jul 2024 22:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKNO+DK4"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA05513C820
	for <live-patching@vger.kernel.org>; Mon, 15 Jul 2024 22:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083524; cv=none; b=pvPCClzxD/xQTmFNQHCktRJhRga9H1GYQqNoF2ni3EaWhc71hJaVa0zPgDukpq+39esd8et8BZ9o812kk+o6gHF37KSJyQIS++gdOCgMA7QNaM9Q4Wo8InydxSWOlWzvw/9MH+BGezSgekgMvlXDwSafIn/zw4206Gi/evnr1hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083524; c=relaxed/simple;
	bh=i1fqEtT1rqOta5R55KZhg82ltlsn6NBHgR+ve0n8icU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=FjH076zshTZIeweXeACH9uBexYP7td+1nuxxNxcFwbPY2NEPyuGaZ8dxSQPqCuGECAQU0StJYxHSDasXcqLUNKWzBOH+PZsZscivzgeeBGBuZ1UQ7+mgj6bc6i4Wa3/OuACvy6us64Z41rFbbFiiGlTpFFqW9rESwA2aB1PW2lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKNO+DK4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4272738eb9eso35472435e9.3
        for <live-patching@vger.kernel.org>; Mon, 15 Jul 2024 15:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721083521; x=1721688321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s0zvchNK8cnWsnxGCjoPAjXFdSKFcute9y52WTtL6VU=;
        b=bKNO+DK4+00NdY2+Z5fOARScZkGwpqEUog3X/kELdnGv7e02SDJUV/PdPBdxkZqElV
         Sk5iL1bAh75YMumkk4mVsF5E80fMuxZ4+kxQJRDzFNpsqad1weUiZVAFLVhU5Z1N9ZJg
         3RGlMfokamp/Hn9Avhrjh95emBOdz/wdIAyWNJbmjaevZKyDf6aoZXRIxnLEg/mxOWAL
         nAYzDeVI8NNV0rzRfVcQhobZpOHfWYi6T7GhBDjk8e2oBX2hhCtRhroz7/RKIoCsktLv
         ofxZaQg3wp2RBLCYPf793FGA2rA8Ez/Jib/Z5B4+W8JO5XpCbLRnT2MvHrYQw+gLEGiu
         +Zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721083521; x=1721688321;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0zvchNK8cnWsnxGCjoPAjXFdSKFcute9y52WTtL6VU=;
        b=wpP95oi+t2GnlR3Rmf9kow4T3tB2meDMUkTgItvdQUei819mGB2Spjrm1V1RSH5Z0q
         Z5e1/ays93NZziECkuyO3B0I6EKzeSR4pOsih6JurXNeZ50fDC3tm/mdyZYoaDBL/z+m
         pZm9qC8btfooC5Y0gGKJbivEW0AU4ufZrTfvxRKD9c+2oiv/bD4S/MPxtJ8iOnVkJClE
         zIIk4x490ES4NN8JNOsY0BESY4mSNCuVQZ2iR6RGRsi0SXDDzCdEEAx6G2jp4G6lWx6N
         WM/50ZZvD/twb0tlUe3cdcCW8QP5zvMm2L2ER8PqS6Io9A6U+XbUu7rAnCK581BQsVmT
         cBKw==
X-Gm-Message-State: AOJu0Yza75nYL08Ohe975Baf2hBUM5FVvbsNY369l+09lZVJjPQjPCEs
	WHEf0oPl2uG2vDzFOTWwN9y7Fbp92U6e5RDQtvZVPhRAkucOB6KDEPiIn1YcMwc=
X-Google-Smtp-Source: AGHT+IEtbkxMLkQ5jizowSwS1B3kOGrpbYF6YcW6xEDXhCV51HIREY7YvqfElHGwtGfVh8a3y65CwQ==
X-Received: by 2002:a05:600c:3543:b0:426:6455:f11c with SMTP id 5b1f17b1804b1-427ba701fd3mr1978235e9.25.1721083520853;
        Mon, 15 Jul 2024 15:45:20 -0700 (PDT)
Received: from [192.168.26.17] ([77.222.24.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f239876sm137243655e9.3.2024.07.15.15.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jul 2024 15:45:20 -0700 (PDT)
Message-ID: <bfbc209f-8f61-4b0c-b0a3-4e8e336bbf42@gmail.com>
Date: Tue, 16 Jul 2024 00:45:18 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re:
To: Joe Lawrence <joe.lawrence@redhat.com>
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
 <ZpWEifTpQ1vc1naA@redhat.com>
Content-Language: en-US
Cc: live-patching@vger.kernel.org, pmladek@suse.com, mbenes@suse.cz,
 jikos@kernel.org, jpoimboe@kernel.org, quic_jjohnson@quicinc.com
From: Roman Rashchupkin <raschupkin.ri@gmail.com>
In-Reply-To: <ZpWEifTpQ1vc1naA@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello.
About upstream commits creating live-patching for which this API would 
facilitate,
I could reference several CVEs:
- CVE-2023-5633
     "drm/vmwgfx: Keep a gem reference to user bos in surfaces"
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=91398b413d03660fd5828f7b4abc64e884b98069

  drm_gem_object_get(&vbo->tbo.base);/drm_gem_object_put(&tmp_buf->tbo.base);

- CVE-2023-6932
     "ipv4: igmp: fix refcnt uaf issue when receiving igmp query packet"
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e2b706c69190

     refcount_inc_not_zero(&im->refcnt)/ip_ma_put(im);

- CVE-2022-20566
     "Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put"
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d0be8347c623e0ac4202a1d4e0373882821f56b0

     kref_get_unless_zero(&c->kref)/l2cap_chan_put(chan)

Only in all of these 3 cases I can remember now, refcount_t is mostly 
used inside wrapper-functions, and from the top of my head now I don't 
remember CVEs that plainly add refcount_inc()/dec().
In case the proposed patch is merged, maybe CVE-2023-5633 would be 
suited best for documentation, or source git could be searched for 
better example.

Two types of problems that you classify, are exactly what I'm attempting 
to solve for added refcount_inc/dec() in the code that is added by 
live-patch. Let's continue with your numbering (1) and (2) for 
simplicity of discussion.

Concerning problem (1), shadow variables are certainly could be used 
instead of my refholder bit in reference-holder structures. That's only 
my preference for simplicity that live-patches code is so often lacking, 
to use one bit in existing structures instead of hash-table based shadow 
variables. But certainly shadow-variables are also a good approach, and 
could be used instead of mine (unsigned char *ref_holder, int 
kprefholder_flag) in the kprefcount_t API.

About problem (2), iterating through all shadow-variable/refholder 
instances would also work, but it is just unnecessary processing during 
unpatch.
In my approach the second kprefcount variable with lifetime of 
live-patch being applied is used, it provides correct refcounting during 
live-patch, but the main idea is that this variable can be just safely 
removed at the unpatch.
The only complication could be values of refholder bits, that must be 
reset at live-patch apply, or probably it is more simple to implement at 
the unpatch, as all kprefcount_t structs are allocated by patch-code.
---
Roman Rashchupkin

On 7/15/24 22:20, Joe Lawrence wrote:
> On Sun, Jul 14, 2024 at 09:59:32PM +0200, raschupkin.ri@gmail.com wrote:
>> [PATCH] livepatch: support of modifying refcount_t without underflow after unpatch
>>
>> CVE fixes sometimes add refcount_inc/dec() pairs to the code with existing refcount_t.
>> Two problems arise when applying live-patch in this case:
>> 1) After refcount_t is being inc() during system is live-patched, after unpatch the counter value will not be valid, as corresponing dec() would never be called.
>> 2) Underflows are possible in runtime in case dec() is called before corresponding inc() in the live-patched code.
>>
>> Proposed kprefcount_t functions are using following approach to solve these two problems:
>> 1) In addition to original refcount_t, temporary refcount_t is allocated, and after unpatch it is just removed. This way system is safe with correct refcounting while patch is applied, and no underflow would happend after unpatch.
>> 2) For inc/dec() added by live-patch code, one bit in reference-holder structure is used (unsigned char *ref_holder, kprefholder_flag). In case dec() is called first, it is just ignored as ref_holder bit would still not be initialized.
>>
>>
>> API is defined include/linux/livepatch_refcount.h:
>>
>> typedef struct kprefcount_struct {
>> 	refcount_t *refcount;
>> 	refcount_t kprefcount;
>> 	spinlock_t lock;
>> } kprefcount_t;
>>
>> kprefcount_t *kprefcount_alloc(refcount_t *refcount, gfp_t flags);
>> void kprefcount_free(kprefcount_t *kp_ref);
>> int kprefcount_read(kprefcount_t *kp_ref);
>> void kprefcount_inc(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
>> void kprefcount_dec(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
>> bool kprefcount_dec_and_test(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
>>
> Hi Roman,
>
> Can you point to a specific upstream commit that this API facilitated a
> livepatch conversion?  That would make a good addition to the
> Documentation/livepatch/ side of a potential v2.
>
> But first, let me see if I understand the problem correctly.  Let's say
> points A and A' below represent the original kernel code reference
> get/put pairing in task execution flow.  A livepatch adds a new get/put
> pair, B and B' in the middle like so:
>
>    ---  execution flow  --->
>    -- A  B       B'  A'  -->
>
> There are potential issues if the livepatch is (de)activated
> mid-sequence, between the new pairings:
>
>    problem 1:
>    -- A      .   B'  A'  -->                   'B, but no B =  extra put!
>              ^ livepatch is activated here
>
>    problem 2:
>    -- A  B   .       A'  -->                   B, but no B' =  extra get!
>              ^ livepatch is deactivated here
>
>
> The first thing that comes to mind is that this might be solved using
> the existing shadow variable API.  When the livepatch takes the new
> reference (B), it could create a new <struct, NEW_REF> shadow variable
> instance.  The livepatch code to return the reference (B') would then
> check on the shadow variable existence before doing so.  This would
> solve problem 1.
>
> The second problem is a little trickier.  Perhaps the shadow variable
> approach still works as long as a pre-unpatch hook* were to iterate
> through all the <*, NEW_REF> shadow variable instances and returned
> their reference before freeing the shadow variable and declaring the
> livepatch inactive.  I believe that would align the reference counts
> with original kernel code expectations.
>
> * note this approach probably requires atomic-replace livepatches, so
>    only a single pre-unpatch hook is ever executed.
>
>
> Also, the proposed patchset looks like it creates a parallel reference
> counting structure... does this mean that the livepatch will need to
> update *all* reference counting calls for the API to work (so points A,
> B, B', and A' in my ascii-art above)?  This question loops back to my
> first point about a real-world example that can be added to
> Documentation/livepatch/, much like the ones found in the
> shadow-vars.rst file.
>
> Thanks,
>
> --
> Joe
>


