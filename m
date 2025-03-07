Return-Path: <live-patching+bounces-1262-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA671A56D03
	for <lists+live-patching@lfdr.de>; Fri,  7 Mar 2025 17:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CE7D17B502
	for <lists+live-patching@lfdr.de>; Fri,  7 Mar 2025 16:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E73221563;
	Fri,  7 Mar 2025 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ejtluj7c"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50500221739
	for <live-patching@vger.kernel.org>; Fri,  7 Mar 2025 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363287; cv=none; b=EMU3hJvKx3d7VTK6w0IQNbjB+EQsi/Sv3OCVKeAksGhkQT0IeP1fhmuvib31MDsC2iaaclt67B6mz/mb+RXieiNVCO2q/i6BVtj169WyZulgfkJq7DBaShoEZkPCQpNOyA1pF1Layyz5342cnAe3NTa5anIzp28sVOO3G+HhuZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363287; c=relaxed/simple;
	bh=iXGYjBWdULJWCrP71xmD0+Dbl0c5VJX4/HXIc9O2icI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=Ox7zqX0tTBp5llzEHIpdGxU38fIULqgggkPp/CXtPPmPQ8VlH0oD27S5EB769gUmZS8ardUDasEFkdmyys5pJLe6bRJcxPHY9IEiSS9y8hpfR7DT10su1cWwBhKAQD7WRlzcJpkICven1zgJgp/Mn3TADo2wNVD0UccH9TMQrqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ejtluj7c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741363284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iYEpkA1N+H9dx8XJCjT8MQ/PI+vw7jshcFKkIi9I5lI=;
	b=Ejtluj7cznK29sWLoiCTPRfwrSplLV+/RMzl0k7Wg+cKsGDs3Ew1e55/a5wpj3WhDN2U4a
	DOXQ+j/QXTcKWav7Vhj6zjD+C5BmE3DbpZMcn4iX3DcStSNi4+uKMTDnicr7ggxfvBKQbs
	TyKiCOMr4kPuVU1hWziFfjpmdN+wd/s=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-nh54ER3kPU-3R2bbV9K7sA-1; Fri, 07 Mar 2025 10:50:45 -0500
X-MC-Unique: nh54ER3kPU-3R2bbV9K7sA-1
X-Mimecast-MFC-AGG-ID: nh54ER3kPU-3R2bbV9K7sA_1741362645
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c0c1025adbso528933085a.1
        for <live-patching@vger.kernel.org>; Fri, 07 Mar 2025 07:50:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362645; x=1741967445;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iYEpkA1N+H9dx8XJCjT8MQ/PI+vw7jshcFKkIi9I5lI=;
        b=BgpqBTO/79g3zU8FpYVX0x9UTB0Rgb16QkbdYfv/yH96KER3LEyHta/qFXfgQP6AoR
         i6u5KbC9il9jC+axWHYZb+A9F3E5A4af83ubjf2Umak+ycloJRRlBMiQ1ZHvcq89BZ+k
         O8n02Wyze5Ap4j/EzM+MullTMGQOVDPpRT6Apc6qEn5kIqEcyUCcR+rdwQXbW0FVRZsG
         ZN80k6RB7ma6WCeFfgrI8VYMtVEUZ5a6uGVZMUrw5cJ0B4PS5uVlyjQhUxXUWEbE07rU
         zM99s0eRP3jDtJ1/MBpCYwkan3u5MwF944sem5cP1cUMP9Bx44y+3q+m+gXu1+wHAySl
         Y5HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKppNBP9cpx9uqa/GZPoY+M45GS24KKnZZVkIajDKQLPa/sl5RZHgY8g7H0pW6JdPSNfjycQ4ogSl31G0H@vger.kernel.org
X-Gm-Message-State: AOJu0YwhNOvfGqRY1wLc5rdPrSxHGVw7ASou7fLZqfFrdUs+EMA70MmP
	8Qedbw3DLWfso4LnTNEpZ8L6O4p10FGgPydKCU39v1kSHDntpY1rtVDxefcm0BG57U+xVV5hLHU
	LDym1pPhE1xZwp6NXiKQIAe3CCvhE44BXGpziGH5tITiqnV3JhzW3BJ4K2v9ete4=
X-Gm-Gg: ASbGncsTGMGcnxwruClwcaE/nqz28NdyTBsVb8U4vsn2y9C7VyKD9YHCvroSP8pinLP
	hNlKQiIyBB12WebH5yuh/6EBYFR3UHy6khVfo9LHfPDi1c0/2B8bY8dshow3gCeocerP60hUHT/
	puO2URaRBigXyHhvnbnVDaQGRnRN/xBkMXRfusCMDBfUMHGIHBVpBByRAfqvihBa/claNqWchIe
	zvu/B6ameI2RXoPqSulVGRDFv+89HaMXREh1hgkPO4KMBfOsNYiC88Gg4owKHoE12VN++sohXcF
	Zj6S5i4dVKLYj07tYNLhGqQkj+7NzhuFDTr4mjWLlbTS8yhLUzir9SL6Krd/ii23eH6XDDbAhQ=
	=
X-Received: by 2002:a05:620a:8811:b0:7c5:3c0a:ab77 with SMTP id af79cd13be357-7c53c0aabe8mr40488585a.4.1741362644494;
        Fri, 07 Mar 2025 07:50:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJbVW//Hd7MkBfbQxMBNrneqKSkHySglXtj4bk8ymVE1LQpMC61/SkaXOudIU+dGIzv8U3DA==
X-Received: by 2002:a05:620a:8811:b0:7c5:3c0a:ab77 with SMTP id af79cd13be357-7c53c0aabe8mr40485785a.4.1741362644127;
        Fri, 07 Mar 2025 07:50:44 -0800 (PST)
Received: from [192.168.1.61] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c3e5339dfcsm258120485a.2.2025.03.07.07.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 07:50:43 -0800 (PST)
Message-ID: <566cfe7c-d5df-6407-6058-b78de5519e04@redhat.com>
Date: Fri, 7 Mar 2025 10:50:42 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Petr Mladek <pmladek@suse.com>
Cc: Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>
References: <20250115082431.5550-1-pmladek@suse.com>
 <20250115082431.5550-19-pmladek@suse.com>
 <c291e9ea-2e66-e9f5-216d-f27e01382bfe@redhat.com>
 <Z8rmCritDCtNmw64@pathway.suse.cz>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v1 18/19] Documentation/livepatch: Update documentation
 for state, callbacks, and shadow variables
In-Reply-To: <Z8rmCritDCtNmw64@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/7/25 07:26, Petr Mladek wrote:
> On Thu 2025-03-06 17:54:41, Joe Lawrence wrote:
>>
>> With that in mind, a livepatch state could be thought of as an
>> indication of "a context needing special handling in a (versioned) way".
> 
> I am not sure about the word "context". But it might be because I am
> not a native speaker.
> 
> In my view, a state represents a side effect, made by loading
> the livepatch module (enabling livepatch), which would need a special
> handling when the livepatch module gets disabled or replaced.
> 

Ok, yeah "side effect" works well here.

> There are currently two types of these side effects:
> 
>   + Changes made by callbacks which have to get reverted when
>     the livepatch gets disabled.
> 
>   + Shadow variables which have to be freed when the livepatch
>     gets disabled.
> 

Right, these are livepatch-native side effects as we're providing the
API to introduce them.  Nothing would stop a livepatch author from using
states to handle their own interesting side effects though.  (I'm trying
to initially think of states in the abstract and then callbacks/shadow
variables are just implementations that tie together in the livepatching
core.)

> The states API was added to handle compatibility between more
> livepatches. I primary had the atomic replace mode in mind.
> 
> Changes made by callbacks, and shadow variables added, by
> the current livepatch usually should get preserved during
> the atomic replace.
> 
>>  Livepatches claiming to deal with a particular state, needed to do so
>> with its latest or current versioning.
> 
> The original approach was affected by the behavior of per-object callbacks
> during the atomic replace. Note that:
> 
> 	Only per-object callbacks from the _new_ livepatch were
> 	called during the atomic replace.
> 

Ah right ...

> As a result, previously, new livepatch, using the atomic replace, had to be
> able to revert changes made by the older livepatches when it did
> not want to keep them.
> 
> This shows nicely that the original semantic was broken! There was
> no obvious way how to revert obsolete states using the atomic
> replace.
> 
> The new livepatch needed to provide callbacks which were able to
> revert the obsoleted state. A workaround was to define it as
> the same state with a higher version. The same state and
> higher version made the livepatch compatible. The higher
> version signalized that it was a new variant (a revert) so that
> newer livepatches did not do the revert again...
> 
> 
>> A livepatch without a particular
>> state was not bound to any restriction on that state, so nothing
>> prevented subsequent atomic replace patches from blowing away existing
>> states (those patches cleaned up their states on their disabling),
> 
> I am confused here. Is the talking about the original or new
> semantic?
> 

... so nevermind about this.

> In the original semantic, only callbacks from the new livepatch
> were called during the atomic replace. Livepatches were
> compatible only when the new livepatch supported all
> existing states.
> 
> In the new semantic, the callbacks from the obsolete livepatch
> are called for obsolete states. The new livepatch does not need
> to know about the state. By other words, the replaced livepatch
> can clean up its own mess.
> 

Yes, the new model means that the last livepatch providing the state
also handles its cleanup on its way out. This is much more intuitive
than the previous semantic (for which I missed the step above :)

>> subsequent non-atomic replace patches from adding to the collective
>> livepatch state.
> 
> Honestly, I do not think much about the non-atomic livepatches.
> It would require input from people who use this approach.
> It looks like a wild word to me ;-)
> 
> I allowed to use the same states for more non-atomic livepatches
> because it might make sense to share shadow variables. Also more
> livepatches might depend on the same change made by callbacks
> and it need not matter which one is installed first.
> 

IMHO the non-atomic world only made sense with cumulative patches.  I
see some folks reporting that separate operating groups are layering
non-atomic patches across subsystems and my head spins.

But we are going to need to consider the use cases (or perhaps prevent
them) for the eventual documentation.

> 
>> This patchset does away with .version and adds .block_disable.  This is
>> very different from versioning as prevents the associated state from
>> ever going away.  In an atomic-replace series of livepatches, this means
>> once a state is introduced, all following patches must contain that
>> state.  In non-atomic-replace series, there is no restriction on
>> subsequent patches, but the original patch introducing the state cannot
>> ever be disabled/unloaded.  (I'm not going to consider future hybrid
>> mixed atomic/not use cases as my brain is already full.)
> 
> Yes, this describes the old behavior very well. And the impossibility
> to remove existing states using the atomic replace was one of the problems.
> 
> The API solves this elegantly because it calls callbacks from
> the replaced livepatch for the obsolete states. The livepatch
> needed to implement these callbacks anyway to support the disable
> livepatch operation.
> 
> And there is still the option to do not implement the reverse
> operation when it is not easy or safe. The author could set
> the new .block_disable flag. It blocks disabling the state.
> Which blocks disabling the livepatch or replacing it with
> a livepatch which does not support, aka is not compatible with,
> the state.
> 
> 
>> Finally, the patchset adds .is_shadow and .callbacks.  A short sequence
>> of livepatches may look like:
>>
>>   klp_patch A               |  klp_patch B
>>     .states[x]              |    .states[y]
>>       .id            = 42   |      .id            = 42
>>       .callbacks            |      .callbacks
>>       .block_disable        |      .block_disable
>>       .is_shadow            |      .is_shadow
>>
>> is there any harm or confusion if the two patches' state 42 contained
>> disparate .callbacks, .block_disable, or .is_shadow contents?
> 
> Yes, two incompatible states with the same .id would break things.
> The callbacks won't be called and the old shadow variables
> won't get freed during an atomic replace.
> 
> It is responsibility of the author of the livepatches to use
> different .id for different states.
> 
> I am not sure if we could prevent mistakes. Hmm, we might add
> a check that every .id is there only once in the patch.states[] array.
> Also we could add a human readable .name of the state and ensure
> that it is the same. Or something like this.
> 

Well, providing the same state twice in the same klp_patch seems highly
likely a bug by livepatch author.  That's worth a WARN?

I'm not sure what to think about the same state id provided by two
klp_patches.  For a atomic-replace series of patches, if the state
content is the same, it's effectively like handing off cleanup
responsibility for that state to the incoming patch, right?  If the
state content changes, that would mean that the incoming patch is
redefining the state... which could be ok?

> Yeah, as I said. The non-atomic-replace world is a kind of jungle.
> It would require some real life users which might define some
> sane rules.
> 

Yup.  I can kinda grok things with cumulative non-replace, but it gets a
lot harder when considering other use cases cases.  I'll put non-replace
aside for now and continue diving into the patchset.  Thanks for the
explanations!

-- 
Joe


