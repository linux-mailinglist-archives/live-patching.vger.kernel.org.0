Return-Path: <live-patching+bounces-2503-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJL6Asmt6mlQCQAAu9opvQ
	(envelope-from <live-patching+bounces-2503-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:39:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C7F3458621
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 98F2F3004D17
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 23:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C53B3793BF;
	Thu, 23 Apr 2026 23:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rw5xsEA/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C3535839C;
	Thu, 23 Apr 2026 23:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776987243; cv=none; b=lGm0I6kIHe6TjDZZeytnJAQ1wajyJ+eJ6jWTgF8WxmrTASZw779LIqDP9VK3RjkTy6l2hy/ZhHdRST4z8ei03dYxMIc00CoJ7ushER14CCxZh9PmCwfGUCsUURUlA79SEYeefal0hedoidGhvSruhymW+8WCgeUQlC4eNh7DpEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776987243; c=relaxed/simple;
	bh=AEpvXuDB8ZmxDrxLg6Bophg4PXBalJik4JFnV/iSOvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxCwjjlq6IJaFL6NdNkSOLtZYhEk90U/cvuoMt8iRY1YnTgfuhsp32aWyyw6oa3CFslqXR4QEO9VeO2zLIJO5izMwOl2Z6RiLlCcvjkmNjdYtvm7lO7Fz0z80Gr3ku9eTWxyQD8Z+F2CI2yaZptXmWbpvaG8BaiASoikQZxa4K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rw5xsEA/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D812FC2BCAF;
	Thu, 23 Apr 2026 23:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776987242;
	bh=AEpvXuDB8ZmxDrxLg6Bophg4PXBalJik4JFnV/iSOvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rw5xsEA/xqy5rxz4a1XlucAHddRNwEbKGIoU3OeeYiIUmST/Rw8Y7uiQSHu1K1Y7R
	 n1Kk8HRXXakl55CJPyoRxIpoMo5heZartM0RNGD/BkmazgMtFTny/LZovwSSxu+pV9
	 KiO1PUE4/STbcOcolSSraeZ+EqY81JdMkXE9Xu4tbRpKG6BXoyZNfH/x5Q1Ixk3ABK
	 Bk3g6UbKid0ZCgPLnAmnv5gWu8O55ztyX6MCVYjCz24JlPuiBaUCPgKGc66xg7pIE2
	 oSZ9myWd+8FMfOp+13vSLYYpo0CBQ8BOt7lxC7ZHckklO9JpHHse0VJ5xZsYJiovLK
	 JSOktk21fZoVA==
Date: Thu, 23 Apr 2026 16:34:00 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 02/48] objtool/klp: Fix .data..once static local
 non-correlation
Message-ID: <tzunpmsnca3pi5ziak6cwrqftdl7oa34jcuy7cm4nrzzfd6276@jkates4giayx>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <f34990d29dd7642ada7843613c96c563043c28a5.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW7rmG_tybJwKdrX+DsKx9a7xA-Qa57njW5r+NyvhT3DUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7rmG_tybJwKdrX+DsKx9a7xA-Qa57njW5r+NyvhT3DUA@mail.gmail.com>
X-Rspamd-Queue-Id: 0C7F3458621
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2503-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]

On Thu, Apr 23, 2026 at 11:54:39AM -0700, Song Liu wrote:
> On Wed, Apr 22, 2026 at 9:04 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > While there was once a section named .data.once, it has since been
> > renamed to .data..once with commit dbefa1f31a91 ("Rename .data.once to
> > .data..once to fix resetting WARN*_ONCE").  Fix it.
> >
> > Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Acked-by: Song Liu <song@kernel.org>
> 
> Nitpick: shall we match both ".data.once" and ".data..once", so that whoever
> backports klp-build to older kernels will not have a surprise.

Hm, I'm a bit hesitant to do that.  One of the nice things about having
this code upstream is that we don't have to start collecting all the
cruft for old kernels.

-- 
Josh

