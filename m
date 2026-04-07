Return-Path: <live-patching+bounces-2316-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GOj7HIIf1Wnr0wcAu9opvQ
	(envelope-from <live-patching+bounces-2316-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 17:15:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D42BD3B0C28
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 17:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 023A0305616B
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 15:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DF235FF58;
	Tue,  7 Apr 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fdh61hJ2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDD735F5F7
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 15:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574488; cv=none; b=P8qU1fCWm2wDk2262EXNcdwacUhjCXFm8OgxV0nUnX3+4SosEr2IC+hrJdipu9oXxeF8xrqW0FMC5QYfUC/x59AF6Ptd4qrqKLwX022zMGZmPT61rgPMNdtfA5uRFcEgEMEuZtzyXh2TBoElL/mZhJm6E0pqIMj5AiKKM+hkqmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574488; c=relaxed/simple;
	bh=ty0KOjKQyTnZaKdoshASSXSZqQBi5bCYN1Ysfs56ZTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7moHkB4Fmkg5l0NnsLhitPLc9IPO9KwY/zeidWXfdedq0O8s+Uo23uRrW241HbkUE+eCdVgHGl57Row4sY5QiHwRaWoelT4ecvBhlNN92mREwQ2m+izrs9144j6WvjtBv3iRifKyjxLkEVrkZiXG5wMSkb1kIlYJaeGaRtWN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fdh61hJ2; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso47721005e9.1
        for <live-patching@vger.kernel.org>; Tue, 07 Apr 2026 08:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775574485; x=1776179285; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iGjzV8IRrkdKa9tu7b5Wnqj/M+3GwqIJMX4TAs0mafs=;
        b=Fdh61hJ2egMuHDvAbE6gAEG/65sTZblgScVS+1N3Vj1HG+HKR43vGkI0SxB6dluWUn
         onOkN9rBRgcJ9rtrNZijPd0J19K4tq4AU9Q9ZqTQHWaw4ZvLTGUIaawaWSmzHKF1emy+
         N947KqfTVR1hijj1VCrVR6wrLIhVNr6MUmUD+7EPTpCv7eSEskkIFRo1shKkZkTuNCzD
         wdrqhes8jYnbjdBPzU1ryaGArly3DhzaQbWX9Q5IrvkW61ZJQAHL1RhTZkWITIV8nwEb
         DuhMeFtjHXFc+FqRGPjhR8r4LbRXvwMQHHcCZyEEyQjyfRv1fgrB9B7PHNXHYqo6Gem6
         ZJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775574485; x=1776179285;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iGjzV8IRrkdKa9tu7b5Wnqj/M+3GwqIJMX4TAs0mafs=;
        b=PcwoHrf2myiohJC/XPLkxFMWnkW4/Qe0kL4gvWKkrMh7sCt5o5OE0mUsHr8Jv7teVx
         vfKCDPZIi5kte+1s7e4MsVwPUcEmHrGpq6se8pb4dGu0h69jDiCHjxOOKAmRhAkU+KLA
         S1LzpVDoChKnVbpq5XCL9rIvGuUEEQ8gEz+uPiCGnnpWSzDPA/fRQurqg7mUasamFJXz
         6Q+AFehrjCytNEfPkj4dPqNqyOqTaECr94Za8ksHxKrFIa7hJzzDCVsGdi0Kwy7GVFEP
         lQyIViclHqZSWHKq4LZamBV5R8p1bev30YvOM+gZZzY6OR9CB7d4RvQgsa0aJnDJRCPp
         1hZA==
X-Forwarded-Encrypted: i=1; AJvYcCWBXx7K5zGsOvNwLwhtjpQFd+ywioG+YiKWqzMI2SRFdl2QTefUzvRV+ZUyO1yIljhlofEa8TE/PsXNCRag@vger.kernel.org
X-Gm-Message-State: AOJu0YwZYeXiCxI2n0pSgjiwyzteP2ItPZ6hvFiqklCZ/li+nwfiKHFC
	oJnAN42W8bykTmXs1h8IPvuz9+8l53osMgqA2vp8ZPEsThaatrKvn3s2hAF9uOKoPNk=
X-Gm-Gg: AeBDietHssYQ4JD6DEfxYT+jfN8YwotCP1xLfAtHzKu2xaIbnrSSBZ8bo7gPA9aYllt
	Co+SfSwwkgW+QcHC8CYlkEcjW8kP0UfOr5jDikzravCS6RGoBmKYVNGY++VfNpFNBLP5/XnjXEi
	D3uxQQaxbAk6orxlbPa0e/sIkm6y5U3+fyEphAI1p0y2qbRoagEnWcjH3oVvA6/Y9M3/IpFu9kD
	nu2cw2Qv0raCUs5k0DxWAxo39Gotf+I2ZT7GEVkB2ixKgcqGz7BKfYwpBpK2+poTjaEk8Bn9KJW
	Yp09ABVTyePxdmElCULmR5msu4NQ07UGH5zMEJQNzkaO0eYyeL5lQhTnrty4cErCkSGDjTNN32i
	4CDjqh480gIsEYYGvWxlyrKm4Rekh0ZUcW3bY1ZUA/NPEaxPI2bu6xSszEeVGAXgzGGFEYN6fBV
	2PNizQ/mAxIUelPBIu6C/S1BDl5y6XUZnNL2tvbcjZJN9mSnqGi3U=
X-Received: by 2002:a05:600c:138f:b0:47e:e076:c7a5 with SMTP id 5b1f17b1804b1-4889970e3c4mr239821275e9.11.1775574484681;
        Tue, 07 Apr 2026 08:08:04 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4888a7165aasm555642275e9.14.2026.04.07.08.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 08:08:03 -0700 (PDT)
Date: Tue, 7 Apr 2026 17:08:00 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>,
	Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, rostedt@goodmis.org,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	kpsingh@kernel.org, mattbobrowski@google.com, jolsa@kernel.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
	yonghong.song@linux.dev, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to
 klp_patch
Message-ID: <adUd0Mojbtrwmeod@pathway.suse.cz>
References: <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com>
 <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
 <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2316-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,google.com,suse.cz,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,pathway.suse.cz:mid,suse.com:dkim]
X-Rspamd-Queue-Id: D42BD3B0C28
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue 2026-04-07 17:45:31, Yafang Shao wrote:
> On Tue, Apr 7, 2026 at 11:16 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Tue, Apr 7, 2026 at 10:54 AM Song Liu <song@kernel.org> wrote:
> > >
> > > On Mon, Apr 6, 2026 at 2:12 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > > [...]
> > > > > > > - The regular livepatches are cumulative, have the replace flag; and
> > > > > > >   are replaceable.
> > > > > > > - The occasional "off-band" livepatches do not have the replace flag,
> > > > > > >   and are not replaceable.
> > > > > > >
> > > > > > > With this setup, for systems with off-band livepatches loaded, we can
> > > > > > > still release a cumulative livepatch to replace the previous cumulative
> > > > > > > livepatch. Is this the expected use case?
> > > > > >
> > > > > > That matches our expected use case.
> > > > >
> > > > > If we really want to serve use cases like this, I think we can introduce
> > > > > some replace tag concept: Each livepatch will have a tag, u32 number.
> > > > > Newly loaded livepatch will only replace existing livepatch with the
> > > > > same tag. We can even reuse the existing "bool replace" in klp_patch,
> > > > > and make it u32: replace=0 means no replace; replace > 0 are the
> > > > > replace tag.
> > > > >
> > > > > For current users of cumulative patches, all the livepatch will have the
> > > > > same tag, say 1. For your use case, you can assign each user a
> > > > > unique tag. Then all these users can do atomic upgrades of their
> > > > > own livepatches.
> > > > >
> > > > > We may also need to check whether two livepatches of different tags
> > > > > touch the same kernel function. When that happens, the later
> > > > > livepatch should fail to load.

I still think how to make the hybrid mode more secure:

    + The isolated sets of livepatched functions look like a good rule.
    + What about isolating the shadow variables/states as well?

> > That sounds like a viable solution. I'll look into it and see how we
> > can implement it.
> 
> Does the following change look good to you ?
> 
> Subject: [PATCH] livepatch: Support scoped atomic replace using replace tags
> 
> Extend the replace attribute from a boolean to a u32 to act as a replace
> tag. This introduces the following semantics:
> 
>   replace = 0: Atomic replace is disabled. However, this patch remains
>                eligible to be superseded by others.
>   replace > 0: Enables tagged replace (default is 1). A newly loaded
>                livepatch will only replace existing patches that share the
>                same tag.
> 
> To maintain backward compatibility, a patch with replace == 0 does not
> trigger an outgoing atomic replace, but remains eligible to be superseded
> by any incoming patch with a valid replace tag.
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index ba9e3988c07c..417c67a17b99 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -123,7 +123,11 @@ struct klp_state {
>   * @mod:       reference to the live patch module
>   * @objs:      object entries for kernel objects to be patched
>   * @states:    system states that can get modified
> - * @replace:   replace all actively used patches
> + * @replace:   replace tag:
> + *             = 0: Atomic replace is disabled; however, this patch remains
> + *                  eligible to be superseded by others.

This is weird semantic. Which livepatch tag would be allowed to
supersede it, please?

Do we still need this category?

> + *             > 0: Atomic replace is enabled. Only existing patches with a
> + *                  matching replace tag will be superseded.
>   * @list:      list node for global list of actively used patches
>   * @kobj:      kobject for sysfs resources
>   * @obj_list:  dynamic list of the object entries
> @@ -137,7 +141,7 @@ struct klp_patch {
>         struct module *mod;
>         struct klp_object *objs;
>         struct klp_state *states;
> -       bool replace;
> +       unsigned int replace;

This already breaks the backward compatibility by changing the type
and semantic of this field. I would also change the name to better
match the new semantic. What about using:


  * @replace_set: Livepatch using the same @replace_set will get
		atomically replaced, see also conflicts[*].

	unsigned int replace_set;

[*] A livepatch module, livepatching an already livepatches function,
    can be loaded only when it has the same @replace_set number.

    By other words, two livepatches conflict when they have a different
    @replace_set number and have at least one livepatched version
    in common.

> 
>         /* internal */
>         struct list_head list;
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 28d15ba58a26..e4e5c03b0724 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -793,6 +793,8 @@ void klp_free_replaced_patches_async(struct
> klp_patch *new_patch)
>         klp_for_each_patch_safe(old_patch, tmp_patch) {
>                 if (old_patch == new_patch)
>                         return;
> +               if (old_patch->replace && old_patch->replace !=
> new_patch->replace)
> +                       continue;
>                 klp_free_patch_async(old_patch);
>         }
>  }
> @@ -1194,6 +1196,8 @@ void klp_unpatch_replaced_patches(struct
> klp_patch *new_patch)
>         klp_for_each_patch(old_patch) {
>                 if (old_patch == new_patch)
>                         return;
> +               if (old_patch->replace && old_patch->replace !=
> new_patch->replace)
> +                       continue;
> 
>                 old_patch->enabled = false;
>                 klp_unpatch_objects(old_patch);

This handles only the freeing part. More changes will be
necessary:

   + klp_is_patch_compatible() must check also conflicts
     between livepatches with different @replace_set.
     The conflicts might be in the lists of:

	+ livepatched functions
	+ state IDs (aka callbacks and shadow variables IDs)

   + klp_add_nops() must skip livepatches with another @replace_set

   + klp_unpatch_replaced_patches() should unpatch only
     patches with the same @replace_set

Finally, we would need to update existing selftests
plus add new selftests.

It is possible that I have missed something.

Anyway, you should wait for more feedback before you do too much
coding, especially the selftests are not needed at RFC stage.

Best Regards,
Petr

