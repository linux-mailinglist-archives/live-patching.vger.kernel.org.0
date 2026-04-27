Return-Path: <live-patching+bounces-2569-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOtDIGuy72n5DwEAu9opvQ
	(envelope-from <live-patching+bounces-2569-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 21:00:59 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7621478E9F
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 21:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 045B2303C00F
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 19:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4AF369996;
	Mon, 27 Apr 2026 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ol7J3ILk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E81285CA2;
	Mon, 27 Apr 2026 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777316451; cv=none; b=ooEwd0LUpMfdwVVBLOfvRdAB82bj1EFiiVYuQaACBe7gVHIDLItVO1/lcdGQh4kxn6gOLPG27yPnSPDacNyVbw/VTHt7tdxMj1GqdcsbRtZGvNsv1v7npBq5jxdPngBAJAyxL6pXz3gCkhy4qEL034Z0UDE4CaFMAdob7UqINa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777316451; c=relaxed/simple;
	bh=7mzhvxp5zZ/YPfDy3On/xp/JGgRcUl6eqWm/A7O4L18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwfpUXpU2OkC8kvqQBA+cTWLZ+z8tau7RAytExrip6Rq8mbUzb40Ly/2ij9m3EUB9gkdD7ZNnxiKMm7c55pnQcOj/2pujZoWq406MctmXPA9E/TSOIcRJCubhYpjh9XEFfujFIZMOdwPn3I6GT4CRAF/MMj15OGZuB5eHIs4c+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ol7J3ILk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F50AC19425;
	Mon, 27 Apr 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777316451;
	bh=7mzhvxp5zZ/YPfDy3On/xp/JGgRcUl6eqWm/A7O4L18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ol7J3ILkyWNtyEgXSYISao/zzSlIWTlqAAidI6zgsBceVtyn59GVDEYRLb6nyMhxW
	 9ALg3lCa2YmyFXQY96NI4YphLeIlMObNQsMar0xHUyb2dmlko5hNFmqMdqfep1rKh1
	 cD4zHt/OjYsnHfE0Xt1yeO7bnbzOnunuF1QBIK8BAOKj5+vHuKg0Xr8lyJKCdFBqSs
	 8DabUBAfFLKQhivppgBleka9Vo8wtoJMq6ncodAXdvjNLnfUg5j6apy4osYg03L06B
	 aNdCtGhN9Da/HELSp8yd4hpwAPamm1HITpM+rGoo1GEU58/w+UJ9JkYZhqH/kzBkWE
	 7rylJnmgco3rA==
Date: Mon, 27 Apr 2026 12:00:48 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 03/48] objtool/klp: Don't correlate __ADDRESSABLE()
 symbols
Message-ID: <3ca4kejjaoy4kj4p2232xtb6rpgog5q7dm65ljq5tvqwp6liij@yfxb3womgfnv>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <ea9af1b6136e9aa11589e592d0fc59e4ef414579.1776916871.git.jpoimboe@kernel.org>
 <177702262868.199199.17632749620515020845.b4-review@b4>
 <alpine.LSU.2.21.2604241133330.25696@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2604241133330.25696@pobox.suse.cz>
X-Rspamd-Queue-Id: D7621478E9F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2569-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	MAILSPIKE_FAIL(0.00)[2600:3c0a:e001:db::12fc:5321:query timed out];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Fri, Apr 24, 2026 at 11:34:33AM +0200, Miroslav Benes wrote:
> On Fri, 24 Apr 2026, Miroslav Benes wrote:
> 
> > On Wed, 22 Apr 2026 21:03:31 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > Symbols created by __ADDRESSABLE() are only used to convince the
> > > toolchain not to optimize out the referenced symbol.
> > 
> > Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> 
> Looking at it again... wouldn't it be better to address this in 
> is_special_section() which is looking at .discard.addressable already 
> (only the outcome is different)?

No, I don't think so.  If .discard.addressable were classified as a
"special" section then klp-diff would try to extract its entries into
the livepatch module, which is completely unnecessary as these are
throwaway symbols.

-- 
Josh

