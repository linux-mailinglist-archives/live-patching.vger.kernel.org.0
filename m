Return-Path: <live-patching+bounces-2048-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PTKHMZ7lmnCgAIAu9opvQ
	(envelope-from <live-patching+bounces-2048-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 03:56:06 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B1A15BCB3
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 03:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C32683004621
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 02:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2163F23BD1D;
	Thu, 19 Feb 2026 02:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KXh4a2mf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EF81C84A0
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 02:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771469760; cv=none; b=SbEDDebzjrj5IV/oVuquCgRwT6VNtOSIN6oUouUVQmLC3peGX9jPIStPbBsEwebBZWNoW7xp359aZHUZvcYaYAFm79sfhEa8WpW7ygsQ/swV3xFzFUkUQgE+odtI8XAd3lCsSW0gdJ3DpWHuAIcdLx7x3F9ZwYKVm3FDc+fQxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771469760; c=relaxed/simple;
	bh=UcjkYRMWL6m/qVCpraCJf3CsX/sRpBCQB8urMl5rqbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jpyzGBzEqAoWdOH25djAGSvPfXoVcy9E8wvfvxMUnctFrYErVmOAFa4xbg1Ck6lUgi7FNH6b6u6msvTrIcvwI/HIJclclJps7LlaeMa9+Cm0DN3EYK4KSPXBaGagvuhAehKQNx5jDEAmpdK5HgJH5DB62rXKVt7a+WNFzzaCD2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KXh4a2mf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31BBC4AF09
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 02:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771469759;
	bh=UcjkYRMWL6m/qVCpraCJf3CsX/sRpBCQB8urMl5rqbw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KXh4a2mfr5atbSpg+hLILgWKsOl9mXUWOMRIdv3XGzLhZRLuYX98ItjsKf5gLDve9
	 lmh1LAd1w1c5A+VVcOqv+P6f/VRKRpMsPN7Hdjt7yY3qovJsOFdFXGG/T3TizFl/iN
	 jFWhTQK0G1Q/8tEG8W1uTFABI2XA1Z4AmCtE7XAFvF+5xBNLXAJtp/rpNBX1seLuep
	 3J3fy6pRtj6fHz0JJ+JvQzzuIoN3hCBpRFHTwcem4PBQaK+OG8qBkUKcRnmSF3ZSs4
	 4HVJy5eJAdrd/g/0uFosJfEIAdmlV1KvVPXHtE/TJFLnHQ44BEg8EagafevugZBCxi
	 yN5t2golVetFQ==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-503347dea84so4310991cf.3
        for <live-patching@vger.kernel.org>; Wed, 18 Feb 2026 18:55:59 -0800 (PST)
X-Gm-Message-State: AOJu0YzSQZ8TncfPwkfa6Jcghcn2x5JYouToG8pXOigIy3NEY847AUzm
	8qcIgCes+93irI52totPbBPxQoOxT3cv5+N5TSIz1TI6jnCN7Pt27EarKg1rZCzJHINeV9iym9L
	bS/vmMxRm0VKYPhuKxrpCuFm0gjr7tvA=
X-Received: by 2002:ac8:58d2:0:b0:501:4e87:70b7 with SMTP id
 d75a77b69052e-506b3f7dafcmr220021071cf.1.1771469758912; Wed, 18 Feb 2026
 18:55:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-14-joe.lawrence@redhat.com> <CAPhsuW6=9OUGdLBR1OhNDk2tbFncGfYe+z7HDr16si06g4AXGw@mail.gmail.com>
 <aZXYO5ZZPV72qOPD@redhat.com>
In-Reply-To: <aZXYO5ZZPV72qOPD@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 18 Feb 2026 18:55:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7jprRZ1kDFB0BvAJjSYhSnwXbXNpT1LgAhsLg+gsn9uA@mail.gmail.com>
X-Gm-Features: AaiRm52OHFNXg340WL5NgvQ1hNKzsCfR7XDojIuUQMnTyPHLQOkUTPwHchpU0ek
Message-ID: <CAPhsuW7jprRZ1kDFB0BvAJjSYhSnwXbXNpT1LgAhsLg+gsn9uA@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] livepatch/klp-build: don't look for changed
 objects in tools/
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2048-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Queue-Id: 79B1A15BCB3
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 7:18=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> On Tue, Feb 17, 2026 at 11:29:13AM -0800, Song Liu wrote:
> > On Tue, Feb 17, 2026 at 8:07=E2=80=AFAM Joe Lawrence <joe.lawrence@redh=
at.com> wrote:
> >
> > I guess we still need a short commit message.
> >
>
> Heh, checkpatch complained, but I didn't think such a trivial change
> needed a full body :)
>
> > Could you please share the patch that needs this change?
> >
>
> Sorry I don't have a specific patch or repro for this one.  I hit this
> during one of my -T, -T -S 2 short-circuiting testing runs.  I got an
> error like this:
>
>   error: klp-build: missing livepatch-cmdline-string.o for tools/testing/=
selftests/klp-build/artifacts/full-virtme-ng/cmdline-string/livepatch-cmdli=
ne-string.ko
>
> to which I wondered why are we even looking for changed kernel objects
> in tools/ ?  That directory may be stuffed with other weird stuff, a
> combination of user-space and kernel-test .o's, so why bother?
>
> I can drop this one until it becomes something required.

I don't have a strong preference either way. I was more curious
about the test case that triggered this.

Thanks,
Song

