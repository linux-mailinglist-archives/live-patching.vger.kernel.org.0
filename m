Return-Path: <live-patching+bounces-254-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F388BF5DF
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 08:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 269E9B21DF6
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 06:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9485017BA7;
	Wed,  8 May 2024 06:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOiMcQGL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A52C8F6C;
	Wed,  8 May 2024 06:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715148129; cv=none; b=rzQyT9d8xCoY3E1BC8jnzAvxudrb3LzR5R0cRKnLTSoPgRXy58tpRcZt3Qn5joxZptaSDtoXt/bYRNQ2CKHHMoL38NXN8UK7fWcJHeVgRjQzXSTH4qkJ3nJ/Lv8JoPl9OxWFSFCf3tOCBcCpMRWPRNTUqS5CeKbFBIa5YeP36Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715148129; c=relaxed/simple;
	bh=J9fI5dO8ghyQSDCvFCEKo1WbFFplxuLlJZv5NdSTXbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UxvXK6+L7ITKZa14m4QgQkIJGpB3Vig96+8oFy3THRKSZTBm2RHFFHYIiUpsD7QNMmKyQo0zQibMvvD7JNtGIXW8xhzL0YjMfh/82S7+caaLI14Nx0+9uYr3epglm6uqqBuO7jAwx6YwS+QU++HgcyLXUT9hqf5gb56lCxIQcT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WOiMcQGL; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-47ef7e85cf0so866509137.1;
        Tue, 07 May 2024 23:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715148127; x=1715752927; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkbFw/zUA3Y1+V2AcAuuyxARNHnY0FdGtKFZnYdUWeg=;
        b=WOiMcQGLdBKB84nN+D8nkPXKm4m4/Fqfg4Ld0hyV9T09usI61sgabHNktz3PMW2cdd
         +LVTFCypNV2ifd3Pz/ivPlUDTRMrJflNQbIFGU5jd4N2mK/LjhKmiS4CePlFseR4gzpW
         iVK3RdTGifhden6TjopjTuaEmxjybwQSC3EP4ms86YABqH5EOXCOQVqCNJDHnXGOnXWx
         sU695CHoU550r1OeMjCwTaFeKNwoIDB3AwRBvSg5l39rl8kUgEOcXpr6fpozVQU5QL3h
         ze8SmZgBWvnoJSqAvcJTbckxhtw5aqPuon1J4N8pRcYD7NFrMTUjNLxHuUFcZ1swQJBd
         Qkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715148127; x=1715752927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rkbFw/zUA3Y1+V2AcAuuyxARNHnY0FdGtKFZnYdUWeg=;
        b=Mqcv3Lf66wHn5Nl2HmHRekkz9Z8klRcwfJywv7gTPVNmspADGSQonJF18oRIqqs5BP
         1qrzIbjzEHLOtBL/nayuhE5M4RpIxdDq+XTGXab6dO4iTS/ZZTumP2owsU7Y1s9AD5Wm
         OyOPQ1hmoFjFulQBeSA5XXRo40dCcT/cUwiR8Jq/u1n1yGAJtCoCQIhXtFmrf6UzYC5p
         PN9MylhdNKqp+VtZTVTnAG8nn/DRSHxLMztjnk4j6cjcENnZR5bpMZ3sv+7u2vWjv4uZ
         lwvGKihG2KtNGt9zQZRbISIy/dNPLo9UXHcDf3U8wZbjLlxLzynTRAwrWkGizdMvUVKg
         F2pw==
X-Forwarded-Encrypted: i=1; AJvYcCWQYN9BV/eWLo+/SI/iSfVmhZ0GclCcV8SIvrpny+wDS2Ju0jPKE2FNkKmj4qQ/SwEzDPdkIqi8y93WXp+YsgZqE8JQYADEPQHJt/4MVMiKA0v7h3GirLsRZ/GEpkjb6ihJNX0Wn+bmTsD7K6U=
X-Gm-Message-State: AOJu0YzYCB++vfLauvPPnyGHMFF7qYb9CGFCpETArvS8AzoHdXDM9xCZ
	sF7cacG7y+LaVt/rusD4uZ75kMJuo0awvzn95uF9pXZnwieHggV8hqeLIBPv++r7l5MUaWENiQO
	rXsDc6uw/WB1ue1ix2ctU5yQVzHw=
X-Google-Smtp-Source: AGHT+IGh4FD2yxtRbWUJYTrgFe15UkqrGTaC/4RWtWVnqwiBFmNHOrlRg0GJvlhUWL13yYy1ualKPFYR2DkKZLSyZrQ=
X-Received: by 2002:a05:6102:b13:b0:47b:c92c:d83d with SMTP id
 ada2fe7eead31-47f3c2cb774mr1931812137.9.1715148127007; Tue, 07 May 2024
 23:02:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240407035730.20282-1-laoar.shao@gmail.com> <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble> <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble> <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
 <20240508051629.ihxqffq2xe22hwbh@treble>
In-Reply-To: <20240508051629.ihxqffq2xe22hwbh@treble>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 May 2024 14:01:29 +0800
Message-ID: <CALOAHbDn=t7=Q9upg1MGwNcbo5Su9W5JTAc901jq2BAyNGSDrg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 1:16=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Tue, May 07, 2024 at 10:03:59PM +0800, Yafang Shao wrote:
> > On Tue, May 7, 2024 at 10:35=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > > User space needs to be polling for the transition to complete so it c=
an
> > > reverse the patch if it stalls.  Otherwise the patch could stall fore=
ver
> > > and go unnoticed.
> > >
> > > Can't user space just unload the replaced module after it detects the
> > > completed transition?
> >
> > Are you referring to polling the
> > "/sys/kernel/livepatch/XXX/transition"? The challenge lies in the
> > uncertainty regarding which livepatches will be replaced and how many.
> > Even if we can poll the transition status, there's no guarantee that a
> > livepatch will be replaced by this operation.
>
> If klp_patch.replace is set on the new patch then it will replace all
> previous patches.

A scenario exists wherein a user could simultaneously disable a loaded
livepatch, potentially resulting in it not being replaced by the new
patch. While theoretical, this possibility is not entirely
implausible.

>
> If the replaced patches remain in /sys/livepatch then you can simply
> unload all the patches with enabled =3D=3D 0, after the new patch succeed=
s
> (enabled =3D=3D 1 && transition =3D=3D 0).
>
> > > I'm not sure I see the benefit in complicating the kernel and possibl=
y
> > > introducing bugs, when unloading the module from user space seems to =
be
> > > a perfectly valid option.
> > >
> > > Also, an error returned by delete_module() to the kernel would be
> > > ignored and the module might remain in memory forever without being
> > > noticed.
> >
> > As Petr pointed out, we can enhance the functionality by checking the
> > return value and providing informative error messages. This aligns
> > with the user experience when deleting a module; if deletion fails,
> > users have the option to try again. Similarly, if error messages are
> > displayed, users can manually remove the module if needed.
>
> Calling delete_module() from the kernel means there's no syscall with
> which to return an error back to the user.

pr_error() can calso tell the user the error, right ?
If we must return an error to the user, probably we can use
klp_free_replaced_patches_sync() instead of
klp_free_replaced_patches_async().

Under what conditions might a kernel module of a disabled livepatch be
unable to be removed?

--
Regards
Yafang

