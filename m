Return-Path: <live-patching+bounces-2582-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KLXgI4bW8GnJZwEAu9opvQ
	(envelope-from <live-patching+bounces-2582-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 17:47:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 222FC4882F0
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 17:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 77B833024C61
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 15:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F2B3C2799;
	Tue, 28 Apr 2026 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcnJVH5T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427AA3A9638;
	Tue, 28 Apr 2026 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391212; cv=none; b=lpcQEJD5ARU8zi7I2buTubrGsn1lru6pK8nBquHPQLco7nXgOsmdsMQ0Ep8f1CErx7hFq/gfNoDaxw5HEbNoaoxgFYQDwPb/3dACgHXSgUv7d9Az10N/csqHc5sH6ZR9qaueU7yJAGLOieZYIapBt6tj5iT9JiLr8nVEWWMfsqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391212; c=relaxed/simple;
	bh=ZHKJH0C0b7JuB87gZ5cDrHkLwnWIhZWz9d4LUP9dLjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kv3IE185QLx5pOzsNWkPw3Pw5t47NTMHBjceLEIPFdJ4knEsWbATKoO6IOnQ2g94OUa0KLzVM4HGvRJ5AkR4rkLEKx21XNz2aqvq69J3fqnJ9ePFh2rr+i5ULYigyURVQxycD2fQLl8abeJ/eM4x6HQKfynaaeuUfnNyyiu0g/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KcnJVH5T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237EFC2BCAF;
	Tue, 28 Apr 2026 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777391211;
	bh=ZHKJH0C0b7JuB87gZ5cDrHkLwnWIhZWz9d4LUP9dLjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KcnJVH5TMDgLX6qyFoZ4JLzRERpLl3QX61D9rRpl89t6vP3PZhsliNf7NpEtb4Awa
	 0CyC55viWPGdIBLsjdLWUiOoWnG5J6SDNVV/7d/J5YwegLHXg2pFPlybdcWtScDKes
	 tRqt7VFDn2lvJAFjGo8GgU3pIbzaNA44t9X3b46dhBpSWERYehMAOlSuizrrvFD4K2
	 BnI09GIA3eyYFuviFu/kMfk2kZwTJQg/4qOX5wSHbkwN3eHW5MbjqjK8IZItXwYOHA
	 nhG6tIpOjLpaRKBR88UI336255o+gvz7pk9fCPctlyGGtzZApduar1TM0dHkIwUz03
	 jsFopXLDJQ6BQ==
Date: Tue, 28 Apr 2026 08:46:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 06/48] objtool/klp: Don't correlate rodata symbols
Message-ID: <roposyrufm52sqyuncxmjvb3e6ghcshrbojkl32ysq2qhkhxos@w4wo6qsme5no>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <602e405888ab38cd08de4375060b56db0965651d.1776916871.git.jpoimboe@kernel.org>
 <177703167198.234971.16690298062704654470.b4-review@b4>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <177703167198.234971.16690298062704654470.b4-review@b4>
X-Rspamd-Queue-Id: 222FC4882F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2582-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Fri, Apr 24, 2026 at 01:54:31PM +0200, Miroslav Benes wrote:
> On Wed, 22 Apr 2026 21:03:34 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> > index ea9ccf8c4ea9..f6597015b33b 100644
> > --- a/tools/objtool/klp-diff.c
> > +++ b/tools/objtool/klp-diff.c
> > @@ -374,6 +374,7 @@ static bool dont_correlate(struct symbol *sym)
> >  	       is_uncorrelated_static_local(sym) ||
> >  	       is_clang_tmp_label(sym) ||
> >  	       is_string_sec(sym->sec) ||
> > +	       is_rodata_sec(sym->sec) ||
> 
> Sashiko comments here [1] that the check is suddenly to broad and it
> covers also global rodata symbols which might then be skipped in
> klp_reloc_needed(). I think it has a point.
> 
> [1] https://sashiko.dev/#/patchset/cover.1776916871.git.jpoimboe%40kernel.org?part=6

Yeah, after looking at this, I'm going to drop this patch.  While
there's no harm in duplicating read-only data, it would break pointer
comparison, regardless of global or local.

-- 
Josh

