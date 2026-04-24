Return-Path: <live-patching+bounces-2546-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Ehe0C83r62k+TAAAu9opvQ
	(envelope-from <live-patching+bounces-2546-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:16:45 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B3102463C2E
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1C3053008310
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BEA20E6E2;
	Fri, 24 Apr 2026 22:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfzOXIl1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129DC1DFFD
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069002; cv=none; b=p054k5qkUlqTpw3S1O2AeocXRdChMI0xDU35aWpMsks17SaoSm4P6J4b42oaCqnpbBySQ/6mSSmwTbO5IPZvXLFKWhKEXiRQxxg9ViagEIV8VbNZLnZjVHuRhtEp5j+3uXS4Waz3+t9H8mRfFhFBtFtZeGBY9snGatt/XLU415M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069002; c=relaxed/simple;
	bh=2QkS5OH8RBG/d0pcZwEXSnzhL4642zRdO9yLgQz02kA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d4RcCN5iJCxVgsfgBDYZDNqzt+UX1TMs2S73odE/Ka++KC42fquuCuUtWOPrHZ0N+x0BwoBZ3HEBb2zTFkhzz5M9g+fWOOZcppZ5DEl2eJqgG0HPXLtDJR01XEBkTqn+2BtwrKimfzecJZFJSi+EtsMwD5eRpZw/PAnv2buyzxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfzOXIl1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85CFC4AF09
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777069001;
	bh=2QkS5OH8RBG/d0pcZwEXSnzhL4642zRdO9yLgQz02kA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lfzOXIl1KxYSEZwVqbWBYhlf7U8DsEOT/3BUKAhsm31agVGOmCIRHtSML4bBnG/Wj
	 iDGaOlvy+kePLy5vWFWbaCR/tiu/IO+gbNGqKXL5bIpYTgLt+gW0dUnfv4NviP6cTz
	 hZS01O8pEgUEMl+5590qCp3fyOvCkNPCZe2rGNuECAwcwCReYddBQlQgDwLf5RdZZa
	 i6+/XAUf5oLYVx0nui+Z5pYg1EB5QopDvT2OXe0Zsax3Kodh2ivFivwfQ30fB8c19L
	 8UhfrPb1Pwm/tUkHEacvzlqLAZXtzYw6dA5QcwSE3fh//UlRBnJuVUTi49TQGEhlF5
	 kd4tWZiNG5ylQ==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8a48deebe95so63845376d6.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:16:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+JYWGP8Ak8ifY3lbtYHKPZPw3PPfGC+TlQnTWO+oAva/dQGwafKKfXTE5N+wzuWKCka2+iaJu7ZkM0dbpo@vger.kernel.org
X-Gm-Message-State: AOJu0YzRl9WNagMfJ16445l7r8zw9Oqwofyu4Auefli1Il9BvC2SW30F
	lDUwLd+cdFoVc64s+mEBFteiEK4bMS9XPPU0T7KC6HRFSLna6k4TbsWdjlfpJX6Ecnskt1z1WOJ
	dQR7QKi8am0DtErDE6aZeT3j+WEbppok=
X-Received: by 2002:a05:6214:5f86:b0:8a0:e931:5fbe with SMTP id
 6a1803df08f44-8b0280ee3d9mr480013516d6.29.1777069000948; Fri, 24 Apr 2026
 15:16:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <1b6557569cbdf893b832c37ba16dafaf69f9c3f6.1776916871.git.jpoimboe@kernel.org>
 <20260423084159.GW3126523@noisy.programming.kicks-ass.net>
In-Reply-To: <20260423084159.GW3126523@noisy.programming.kicks-ass.net>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:16:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5JnWvCC1XeTFwcp6_3yGF2n-M8ymQ=bZfxr3bzwEixdQ@mail.gmail.com>
X-Gm-Features: AQROBzASb78ZT5ntIpmSpgPL_3SQtQQkOVQYi2ey16Wba_jmiMPVjiWH3pPiKh4
Message-ID: <CAPhsuW5JnWvCC1XeTFwcp6_3yGF2n-M8ymQ=bZfxr3bzwEixdQ@mail.gmail.com>
Subject: Re: [PATCH 34/48] objtool: Consolidate file decoding into decode_file()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B3102463C2E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2546-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,infradead.org:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Thu, Apr 23, 2026 at 1:42=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Wed, Apr 22, 2026 at 09:04:02PM -0700, Josh Poimboeuf wrote:
> > decode_sections() relies on CFI and cfi_hash initialization done
> > separately in check(), making it unusable outside of check().
> >
> > Consolidate the initialization into decode_sections() and rename it to
> > decode_file(), and make it global along with free_insns() and
> > insn_reloc() for use by other objtool components -- namely, the checksu=
m
> > code which will be moving to another file.
> >
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Acked-by: Song Liu <song@kernel.org>

