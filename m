Return-Path: <live-patching+bounces-2870-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGONJWPzDmqmDQYAu9opvQ
	(envelope-from <live-patching+bounces-2870-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 13:58:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CE25A459E
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 13:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 06DC53010DA8
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 11:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB6E3C8C55;
	Thu, 21 May 2026 11:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YawXK3qo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ytU1Rs4C";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YawXK3qo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ytU1Rs4C"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4993E3C8C60
	for <live-patching@vger.kernel.org>; Thu, 21 May 2026 11:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779364427; cv=none; b=SsthjdNgo5evSgbKYoO6qmjSrZ5tN720fYYW0zTx0M4nKKtq1GtdzbBQJMoPkhWyxy5DpJigE4KLESwuR2HlSKuRV7cbNVxR3z0Lxuyh3j/mDxLWl68AKzDFqeMknSvzJIUnco60Gb5LInCURQHB7E1g33iikRT4pR3f4fUkzdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779364427; c=relaxed/simple;
	bh=ogPFkY+WitEERwL2m5OfHSmHmUChtcyk+7ER9e5B3bA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HPec7KNyVmCYz80K4yMhHtwhu6s/NrwxngKCKTw1At34Xom1cluK0E44jBBn2GmWGP9RAj1/nN6UYLIORWPCF2WM2GIHukyifEftQNiXHEurp0K4pVQJcBsHOqi0tlj1PUw5DJA/OtoObg05MzvHZUtzCIfmy2bfdatQoNTZVv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YawXK3qo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ytU1Rs4C; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YawXK3qo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ytU1Rs4C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B72F6AE1E;
	Thu, 21 May 2026 11:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779364421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mg5EJr8FDgyEbmlI45mdIldxqSgNMCoMde9zBBwXohI=;
	b=YawXK3qonKEgiyfNN+dUnuP4U+l1T4xnMIVZDyYKGCG9HIaWlQxENNeyQuw+MBlUNSKm1i
	F7CfgMT/AuznuQPyhj7TgtOt076vhrIL0/Tp1wiqrULGG7YApJSTlxiJf59U4nR29vROdn
	EOdE0aD0RKKu2OLwJOI+wn7ezhXYLvk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779364421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mg5EJr8FDgyEbmlI45mdIldxqSgNMCoMde9zBBwXohI=;
	b=ytU1Rs4CTTLrJqYUSv2EmVrIwztQI0rKkh/BBMCuRy7EVr7m0FXIJ6YB/TD78S+9+x19ds
	71VmYBV74Rm3MrAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779364421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mg5EJr8FDgyEbmlI45mdIldxqSgNMCoMde9zBBwXohI=;
	b=YawXK3qonKEgiyfNN+dUnuP4U+l1T4xnMIVZDyYKGCG9HIaWlQxENNeyQuw+MBlUNSKm1i
	F7CfgMT/AuznuQPyhj7TgtOt076vhrIL0/Tp1wiqrULGG7YApJSTlxiJf59U4nR29vROdn
	EOdE0aD0RKKu2OLwJOI+wn7ezhXYLvk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779364421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mg5EJr8FDgyEbmlI45mdIldxqSgNMCoMde9zBBwXohI=;
	b=ytU1Rs4CTTLrJqYUSv2EmVrIwztQI0rKkh/BBMCuRy7EVr7m0FXIJ6YB/TD78S+9+x19ds
	71VmYBV74Rm3MrAg==
Date: Thu, 21 May 2026 13:53:41 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: luhao <lu.haoA@h3c.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org, zhang.chunA@h3c.com, wang.shijie@h3c.com
Subject: Re: [PATCH] livepatch: Improve the accuracy of symbol search
In-Reply-To: <20260516080833.218948-1-lu.haoA@h3c.com>
Message-ID: <alpine.LSU.2.21.2605211348470.31340@pobox.suse.cz>
References: <20260516080833.218948-1-lu.haoA@h3c.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2870-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: D7CE25A459E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

thank you for the patch...

> module_kallsyms_on_each_symbol, when the input parameter modname is not
>  empty, only searches for symbols within the current module.

Yes, correct.

> When
> patching a kernel object (ko), if the patched function calls
> functions from vmlinux or other ko modules, symbol lookup may fail.

dtto, expected behaviour.

> When patching a ko, the current approach first searches for symbols
> within the module itself. If not found, it uses
> kallsyms_on_each_match_symbol to search in vmlinux. If still not
> found, it calls module_kallsyms_on_each_symbol with modname set to
> NULL to search across all ko modules. The reason for not searching
> across all ko modules from the start is to avoid issues with
> duplicate symbol names.

No, your patch would break things. What are you trying to achieve? Is it 
motivated by a failure or an issue that you met? Could you share it, 
please? There may be a bug somewhere but it is difficult to judge without 
data.

> Reviewed-by: zhangchun <zhang.chunA@h3c.com>
> Reviewed-by: wangshijie <wang.shijie@h3c.com>

Drop these tags next time, please. The review happens here in the open.

> Signed-off-by: luhao <lu.haoA@h3c.com>
> ---
>  kernel/livepatch/core.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 28d15ba58a26..9c587cc4896b 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -167,9 +167,14 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>                 .pos = sympos,
>         };
> 
> -       if (objname)
> +       if (objname) {
>                 module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
> -       else
> +
> +               if (args.addr == 0)
> +                       kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
> +               if (args.addr == 0)
> +                       module_kallsyms_on_each_symbol(NULL, klp_find_callback, &args);
> +       } else
>                 kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
> 
>         /*
> --
> 2.51.0
> 
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????????????????????????????????????????????
> ??????????????????????????????????????????????????????????????????????????????????????????
> ??????????????????????????????????????????????????????????????
> This e-mail and its attachments contain confidential information from New H3C, which is intended only for the person or entity whose address is listed above.
> Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited.
> If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!

I think that you do not want the above disclaimer when you submit a patch 
to an open source project. Could you fix your email client, please?

Regards
Miroslav


