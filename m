Return-Path: <live-patching+bounces-2531-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MBfCBR3l62m9SgAAu9opvQ
	(envelope-from <live-patching+bounces-2531-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:48:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BDBF463902
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 43870300B06B
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F099336884;
	Fri, 24 Apr 2026 21:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaTRii4D"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09C1285041
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067288; cv=none; b=fE2PMKYwdgmZ6QZPPmcB8nj8T/RP2urF80HEEZ2Jt5uBtEr4dlKBAGI0aXjcf+ohibyKd6PqAtzMDaSxb4ZNhVap2jP6Jduolwk6MOsGLNbK2S62Gr7tePgkmcCGG0ESJxwU9ppXpcb4hLWEfvIZhDhsHJYXxej/WgZWjz5eU2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067288; c=relaxed/simple;
	bh=UO75qcoQPgMLMOUuU6pHy1tUJ+nWpNNefd2g4O0RMak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a1qDYXez/k/GAhAwTTEWGs/lyQRejyZkJd74aahPTVjlUFXJqqr9as1EJ0FrWN11jJ4Wtz0T8KdE7JwutYF/dfOsTjxo4izal2Sqdd9S7gDEr4dBfQ4IzcpIkq+1TSzHYjYn/qZnrRFdH0KaCJoiTqzKnlEVvUHDHvWjVfnUa0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaTRii4D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7E0C19425
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067287;
	bh=UO75qcoQPgMLMOUuU6pHy1tUJ+nWpNNefd2g4O0RMak=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HaTRii4Dn1dRIFwLG/bKrBUAVhYcCfzQ1CzLkBgqYrC7+ay3YLQLUhGJG1xJxehWO
	 1Jaw1NjoNbLm9HnKfBCLA0u7r1bIMgSh/9ahSIUZiiXNMLqrYqZgs+ArCftZ8q+eEg
	 42bfmQvwRkavfAHUKdM1ZjkheSB3f/WWa6fgp0GdZvSfcwfVMlQVm/LAjAK3BuEhtI
	 ZTxTh7UFUZiEbMdtEI6EtKsXUkeLuFaFdeej2CqB0MlIxKoYincVEaB53SI7/eIF6i
	 UG4S9A+QVSy7LP5DUOrk5/NU16sqWeKPkzCWB5nDzfI20Te6SPfjC4ixXsSmk3i6Dq
	 fSfWMAh3gp4cw==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a5800772f3so61981756d6.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:48:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8qYtfLJBrZBcSVyYCnaM8906ct0q/CdDN/O6NNlkhtk+6eQvhRNLRn+rIstkychkpehQLqcUzPBLr8Y9Yp@vger.kernel.org
X-Gm-Message-State: AOJu0YyPQWVA2TaqmZOdRoyn9bcG/x1Ukp0Q1VdGsOneSXL6MQXeHNLD
	/owKUGSRU0P/B31FGY2m9o83dgUKfku7XGaFWZ5RosqA4XwKdqZAnlqU/KdOK+SaJzJ7ei5Najx
	DfDq04anNv1XwfXvuaLqHpylwRlcPyfw=
X-Received: by 2002:a05:6214:6107:b0:8ac:a6f7:8a72 with SMTP id
 6a1803df08f44-8b02814ff4bmr471187036d6.43.1777067286798; Fri, 24 Apr 2026
 14:48:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <09dab1995c4ba6ca29dd70b0a7472f1a2975fefd.1776916871.git.jpoimboe@kernel.org>
 <20260423083231.GS3126523@noisy.programming.kicks-ass.net> <dzwdrnewwsabz5zmbwkyq6tv4vqn6rauhfyuiywwsifxgh7bow@rplzpdtwsafc>
In-Reply-To: <dzwdrnewwsabz5zmbwkyq6tv4vqn6rauhfyuiywwsifxgh7bow@rplzpdtwsafc>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:47:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW76j3V4Us1Jjnhcy_9Fab_bSBqP6U28fYKZ8wcO81RBdw@mail.gmail.com>
X-Gm-Features: AQROBzCptgv2CHrsn-ia2_HT188orNBT7jxDFh1-0dgB-RRE396-R7qxfx4xHAM
Message-ID: <CAPhsuW76j3V4Us1Jjnhcy_9Fab_bSBqP6U28fYKZ8wcO81RBdw@mail.gmail.com>
Subject: Re: [PATCH 17/48] objtool: Fix reloc hash collision in find_reloc_by_dest_range()
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7BDBF463902
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2531-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Thu, Apr 23, 2026 at 9:34=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Thu, Apr 23, 2026 at 10:32:31AM +0200, Peter Zijlstra wrote:
> > On Wed, Apr 22, 2026 at 09:03:45PM -0700, Josh Poimboeuf wrote:
> > > In find_reloc_by_dest_range(), hash collisions can cause a high-offse=
t
> > > relocation to appear when probing a low-offset hash bucket.
> > >
> > > Only return early when the best match found so far genuinely belongs =
to
> > > the current bucket (its offset is within the bucket's stride range).
> > > Otherwise, continue scanning later buckets which may contain
> > > lower-offset matches.
> >
> > Maybe mention (and or add a comment to the function) that in case of
> > multiple matches in the given range, it will return the lowest address
> > one.
> >
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index c4cb371e72b2..af2841b8e095 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -347,8 +347,9 @@ void iterate_sym_by_name(const struct elf *elf, const=
 char *name,
>         }
>  }
>
> +/* If there are multiple matches, return the first one in the range */
>  struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct sec=
tion *sec,
> -                                    unsigned long offset, unsigned int l=
en)
> +                                      unsigned long offset, unsigned int=
 len)
>  {
>         struct reloc *reloc, *r =3D NULL;
>         struct section *rsec;

Acked-by: Song Liu <song@kernel.org>

