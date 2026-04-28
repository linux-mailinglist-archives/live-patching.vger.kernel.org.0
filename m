Return-Path: <live-patching+bounces-2585-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMP2AU/g8GmoagEAu9opvQ
	(envelope-from <live-patching+bounces-2585-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:29:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 78ECE488E4C
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:29:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CF293080EAF
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 16:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99C444A71C;
	Tue, 28 Apr 2026 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM875fx9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CE7441022;
	Tue, 28 Apr 2026 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392880; cv=none; b=mcH6567vTr5wZav9G6wpddB9YPfNewKe9TndS7rx0naEaWS9q1trdoXjeanJO/NlUZtUfsZZ2HI8OijLvx/1QeySnd8wtn4CKzxQr5rW84Bny9MbBPBnAmmXde6UYxVNwck65asg/zExsj722apYyuFxF7knhTTiD5cXaMDAioA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392880; c=relaxed/simple;
	bh=CPUYEqVRAarPXNaMkzwcGIW59ajwxAMrIorC5VSFggA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qOTfpSx8Xsf/0LCF6CIfVttzGj7m/lHGAOkPtV0slEy0yZ+x3hu9wvla0/80HOaWQEairnKHKL/TntQ2jnBlYJMQZSYmLUbcHW0gZMVekEA15y5maFbyMb6U1KjJQLmMVbMVEQDFH6MO4EkRekzGxQadMhyfDxoAB1oIYY4ebIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EM875fx9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913CEC2BCAF;
	Tue, 28 Apr 2026 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777392880;
	bh=CPUYEqVRAarPXNaMkzwcGIW59ajwxAMrIorC5VSFggA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EM875fx97im26wG8B0+vX1KV95Vk4L8TeKMUuC27Vcg8iSkHhmKsKZtpu9FbZLhL/
	 yOInh1nIEX2boLo9nPKbQJd7FQ8IYmA8akAHf9b69GwwrEcCHYAlXlx0cQQo9Kz5i3
	 +MMz8IbpPTnCzLcX/TBUII+eTRx8ioLeGS3V3PF8KgZb+dJ7+9o8/kzcdxZFW/EsPv
	 j8x1mB3o26ByaR8tCmYb17EHFb3rAVCPD+GD+7S8cmJCwKaRftwxThzrQ+13axF1KZ
	 84KN7fR/5/JffnJt0Du6GXscpbehmfPRkfh9D5xMU6BsYW+nJrCQjitvWxcjQT3kl4
	 mronJNkMoITMQ==
Date: Tue, 28 Apr 2026 09:14:37 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 39/48] objtool: Replace iterator callbacks with
 for_each_sym_by_*()
Message-ID: <hvetzvby2f2gj7txal3apitn5ny364rtwexfei7qyornsr4bpn@kijmg6altcxt>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <03f7804ae62c5c4521053afc3f6a1c4a11bc85de.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW7=EAeOT3cTvROoDVcvU6wibF56nJFPQzXQhnVcxfmPrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7=EAeOT3cTvROoDVcvU6wibF56nJFPQzXQhnVcxfmPrw@mail.gmail.com>
X-Rspamd-Queue-Id: 78ECE488E4C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2585-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Fri, Apr 24, 2026 at 05:04:08PM -0700, Song Liu wrote:
> On Wed, Apr 22, 2026 at 9:04 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > Convert the callback-based iterate_sym_by_name() and
> > iterate_sym_by_demangled_name() callers to use new
> > for_each_sym_by[_demangled]_name() macros.  This eliminates the callback
> > structs and functions and makes the code more compact and readable.
> >
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  tools/objtool/elf.c                 | 80 ++++++-----------------------
> >  tools/objtool/include/objtool/elf.h | 40 ++++++++++++---
> >  tools/objtool/klp-checksum.c        | 20 +++-----
> >  tools/objtool/klp-diff.c            | 42 +++++----------
> >  4 files changed, 73 insertions(+), 109 deletions(-)
> 
> Macros are indeed cleaner. But Sashiko has a valid point on this. [1].

Ok, I'll make those an "if (mismatch) {} else":

#define for_each_sym_by_name(elf, _name, sym)				\
	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash,	\
				   str_hash_demangled(_name))		\
		if (strcmp(sym->name, _name)) {} else
-- 
Josh

