Return-Path: <live-patching+bounces-2219-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKuTOV6kuWlILgIAu9opvQ
	(envelope-from <live-patching+bounces-2219-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:58:38 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6770B2B14A9
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:58:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C6FF3048EE8
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 18:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5143B3F7863;
	Tue, 17 Mar 2026 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTWxHE6r"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFCA373C1F
	for <live-patching@vger.kernel.org>; Tue, 17 Mar 2026 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773773914; cv=none; b=AuTuY2jbRCBWVmHVc//FftalI06IR6IE8USs+RFicF00FgYFLmKRV/bn9oCjdnKd4P8Ul0ceKzxZ2R11SjdhhySlN/YIr8TqXsBovS71yrXRBSYo1FB6U2CN1Fi2gGh5z7JaQXKHVgR/L8xc4jcZz10O6zNu6kfk0SScTlzGphc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773773914; c=relaxed/simple;
	bh=0MWUHSAwpDtTZhkoB0VGBEBQP7iB0D0FC4PVbwLZma4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6cUTJp32ekbGscvjt34DXVT7NK5joBqNSKg2k1XJR5t30UeNBJjDLGnKS8jPOmLMyhx9aLOfz98TqUfbeKONPwAu1MUEaB2+xS0tQTEWeOPXirRQUh/6ZrlBGKeMJTeqCb38tzyLTidAvtrLyGqp4zCqY/qb5OKOcrdsIdzLKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTWxHE6r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DACC2BCB4
	for <live-patching@vger.kernel.org>; Tue, 17 Mar 2026 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773773913;
	bh=0MWUHSAwpDtTZhkoB0VGBEBQP7iB0D0FC4PVbwLZma4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hTWxHE6r669cdqqPr/P8Rx9IKoqnMICPCwP4q6DypB0vIxI6KblJmuncDJTkiuB/t
	 R3cK5boMjOTqq6SCAunmJ3meYGLIeJAmCAv5uYXl+eadjoLWEy4kQd2UxWuegMUFE5
	 QKPFaViZQqCHg0JluGBhdSDxqWkefi2uZqq5OeQkQvG4KTdS2g62TwUDIkGk+fe8SA
	 t/Eg96egMdmwn1hfOsAhfgNs+pwp3i6BetrpmIBfFJDkH8CxBcPO3LQofQUkUnCxXy
	 w69BIW24l0GqcE/Q5PnyBW875Juy9+ET+KEVW+kz2aAeqfwi1iqvDvfC9cqcTfxGZi
	 KYNDrLb5IOyXQ==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899ee87355dso82852296d6.1
        for <live-patching@vger.kernel.org>; Tue, 17 Mar 2026 11:58:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW7uUI0rz9CcqaqqCs+QB896MtlNqftOvEf/1JeoIwpCqcbZ2EkZD/QH97NyyiiEpDA4sSvTolhexe0+B9P@vger.kernel.org
X-Gm-Message-State: AOJu0YxuvvPe8EgBjXTnjLFJb4jlEvNKZz/xLX4Izrd/cUgA/OML+xMU
	GthpjRfnKSC7eIXN3+nizVRXMJXVELz9qPAOIYZTFSJoemBLLrWTVaf011BZUyj5vVKhXBssBRu
	BoH1j1QBkHV8OW8S8XHJmAfZf11Lz5lo=
X-Received: by 2002:a05:6214:248a:b0:89c:4c6b:4615 with SMTP id
 6a1803df08f44-89c6b4eab88mr10421846d6.8.1773773912991; Tue, 17 Mar 2026
 11:58:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <697c09ca0a8ffd545aa875e507502f62ad983419.1772681234.git.jpoimboe@kernel.org>
 <CAPhsuW6Cyw_z+9sWt5G1XOp94z8BbwNmsoVE9=iM8WQfkuNDBA@mail.gmail.com>
 <xzezfjfb5uttvmg2divzk3toym3qqvkh5c4w2enamsrku342m3@bogfmdj65wql>
 <e2yxamlxwif5kxur7thr4x7yp7ppbde6awzm6vomdfkg6auxeq@aaahh3aclf2e>
 <CAPhsuW6SsDTDCJ8-w9OP3FeS2d0Rj6jgP7gYbzD3pZhAmK5nAg@mail.gmail.com> <74fwwcyggggcnh7pj2i7nhglhagltkqeth4ykhtqs4izx4dtig@lzyai66d2vn6>
In-Reply-To: <74fwwcyggggcnh7pj2i7nhglhagltkqeth4ykhtqs4izx4dtig@lzyai66d2vn6>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Mar 2026 11:58:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW72qYhR0xNfsx8jhrA+P4EmZrB3j+ezG=JOkfKh0vmopw@mail.gmail.com>
X-Gm-Features: AaiRm52jPD_LPP04lC-wsy0kauFeBENhLM0ZkkRmw5VscAMPgFc8WtFAeLbaxic
Message-ID: <CAPhsuW72qYhR0xNfsx8jhrA+P4EmZrB3j+ezG=JOkfKh0vmopw@mail.gmail.com>
Subject: Re: [PATCH 14/14] klp-build: Support cross-compilation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2219-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 6770B2B14A9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 17, 2026 at 11:53=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
[...]
> >
> > Do we need ARCH when CROSS_COMPILE is set? I was
> > under the impression that CROSS_COMPILE doesn't require
> > ARCH.
>
> If CROSS_COMPILE is used without ARCH, it will just try to use the host
> arch.  I'm not sure if that's considered cross-compiling?   I suppose it
> should use the CROSS_COMPILE version of objcopy in that case?  Though in
> practice it probably doesn't matter.
>
> I guess the original version of the function is probably fine and we
> don't need to complicate matters.

Agreed that the original version works fine. Thanks for bearing with my
nitpick on this.

Song

