Return-Path: <live-patching+bounces-1992-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOeWK7XLhGk45QMAu9opvQ
	(envelope-from <live-patching+bounces-1992-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 17:56:21 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 23098F58DB
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 17:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD20A303AB4B
	for <lists+live-patching@lfdr.de>; Thu,  5 Feb 2026 16:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB62438FEB;
	Thu,  5 Feb 2026 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuzGm9dh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84343637F
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310223; cv=none; b=rZo0GptdVKGda9oEz7edFOAGy+mtypsOJWsTjwc72sgxCSdH9K5AkaG1k1hyq0D/LkR7T/FaQs+9vorhOylAsKQQWhrGAc8CHPfHl8CAEJ970a3raJ017tm+b9GSMpdwJGL0s9G5WtLKFTsUSGPp/T3JvAgx1Li6jGXRdotMoSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310223; c=relaxed/simple;
	bh=i2l4OIdGbqm3tV0XibzaeZujd7WGFKqgyfL08M7mCr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5bYrto/IB4uRUR8Rc8MuiyZxH4TF//y8yLhv23SsQBUT/RmUnFsVRYl9IjSVROBp6xeENzfJA2THwhh46l/Bi1vJLKyXHlnRlgra4CuvZ/evuZVgS6PbE2FeKpoG5DVjfoSIa08RosptvOK73j2H5sztWh7to3G17s93LagLSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuzGm9dh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5702DC4CEF7
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770310223;
	bh=i2l4OIdGbqm3tV0XibzaeZujd7WGFKqgyfL08M7mCr0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SuzGm9dhjjC/88JRiwRheDxnpnyZdQ6nYfIlmU4ng9hA2nGVHTn6Hy6QPtv2TngIm
	 GtGyjzD2T7eZlyY8ibu2YSsApUqoR+9h92qtevh18WxKIucTNTkM1nDk9pC2F2oDD4
	 5oTzQXOEMrdxcCAsXZx3vruxu5DT/4P3YOGsAPpQPrr2XVATkKhMb/EhmcDxfYyvHS
	 II9K2n1hhhD7f6+qEzkBGgodXyoDJj1d5MKAC+3pWO3R8daSJgmToVlgvz3M/F3zc9
	 4jfIemKypco3LhPAFpZLnh16OTKhwbsotw/VHH08MAsl2q4XgU8k5jvEtM2dlyGsFh
	 d4SMDA+Z8EMiQ==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5013d163e2fso14086451cf.0
        for <live-patching@vger.kernel.org>; Thu, 05 Feb 2026 08:50:23 -0800 (PST)
X-Gm-Message-State: AOJu0Yx1YAypSe6iU3tMPwBx1VJZPQpDU8lTq7b6WJwo4pjn0nPaqHED
	GmR4xD1aC2B7vHsUzepMtW9Ua9cDG0Mjh+AVgrCDbj1g8WDE+SZ5n5YHQuhTEdcZ8/DkITYAFNh
	Djfo265YGzRaEbKE1uv1u+f4c4k5aOxQ=
X-Received: by 2002:ac8:7f49:0:b0:501:4c41:989f with SMTP id
 d75a77b69052e-5061c1b30a5mr83745571cf.69.1770310222560; Thu, 05 Feb 2026
 08:50:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129170321.700854-1-song@kernel.org> <gqqr3ulqbhecvev36ry7nlra3fysgltlpiv2lzsil7ewrwy7qx@dlp77z56npqc>
In-Reply-To: <gqqr3ulqbhecvev36ry7nlra3fysgltlpiv2lzsil7ewrwy7qx@dlp77z56npqc>
From: Song Liu <song@kernel.org>
Date: Thu, 5 Feb 2026 08:50:11 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7DrOqq6Neu_fgxt9V1Zpz+_o8VobvO_OdkJt_WGzKvSg@mail.gmail.com>
X-Gm-Features: AZwV_Qg7fTs4tylLPl6qEBa1LHm5u9oTY_gfdPM8c5fUI0RywHmYl_tPb4qWFo8
Message-ID: <CAPhsuW7DrOqq6Neu_fgxt9V1Zpz+_o8VobvO_OdkJt_WGzKvSg@mail.gmail.com>
Subject: Re: [PATCH] klp-build: Support clang/llvm built kernel
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, kernel-team@meta.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1992-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 23098F58DB
X-Rspamd-Action: no action

On Thu, Feb 5, 2026 at 8:25=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Thu, Jan 29, 2026 at 09:03:21AM -0800, Song Liu wrote:
> > When the kernel is built with clang/llvm, it is expected to run make
> > with "make LLVM=3D1 ...". The same is needed when building livepatches.
> >
> > Use CONFIG_CC_IS_CLANG as the flag to detect kernel built with
> > clang/llvm, and add LLVM=3D1 to make commands from klp-build
> >
> > Signed-off-by: Song Liu <song@kernel.org>
>
> Peter informed me that "LLVM=3D" has different syntaxes:
>
>   LLVM=3D1
>   LLVM=3D-22
>   LLVM=3D/opt/llvm/
>
> Debian has parallel llvm (and gcc) toolchains, and suffixes them with
> -$ver.
>
> So we dropped this patch for now.  "export LLVM=3D1" still works.  Not
> sure if you have any other ideas?

Hmm... I guess "export LLVM=3Dsomething" is probably the best option
for now.

Thanks,
Song

