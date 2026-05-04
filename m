Return-Path: <live-patching+bounces-2696-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kND3AZap+Gm6xgIAu9opvQ
	(envelope-from <live-patching+bounces-2696-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 16:13:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB654BED96
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 16:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D47C13040EC2
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 14:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373713DE43B;
	Mon,  4 May 2026 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XN7pbcJu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MRE9VgBv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XN7pbcJu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MRE9VgBv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE7D21CC4F
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 14:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903507; cv=none; b=cKkE0AlPi9QlG8YvMJekfgtvP/16r45CFsgVDBpytRef03jdSwI3d/lMGNE7gu+uTwSYVRebeKeS1pBH4LeM1FVYGJ68lVT6mi15RrSMi84zukO1uvgykL1wihTs/FBz1sIfYApGhgyt8DS3RSU3wdre84kNL4OHm7nErhqRXy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903507; c=relaxed/simple;
	bh=Dcnje7nyZZnn5Ul3fkRGXdjBjdUoLI3iuJ+sB74uYCc=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=gsUXboBqQK5PRDM+TdqoUOWVOnQHlgzf34Qh3pZq7n1+dTzj5BIFgMr8nOeu6UxhprjCNP493sAQNjS/YtObJsg+ECJxhhwv1uRRM865XqCyqxzNekPt46WWvQHWL2+HH2JR3YWL903zTgYnZmBqcZXk4IETeLyfrSjhqnWE6jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XN7pbcJu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MRE9VgBv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XN7pbcJu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MRE9VgBv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:2b::1244])
	by smtp-out1.suse.de (Postfix) with ESMTP id D54836B28B;
	Mon,  4 May 2026 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777903499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4P7MFhSaj3vw5vvBDvqAjWIzIlF+CIm5GapKhhYDCU=;
	b=XN7pbcJuXfdIpp6juuySwcdvcDfBREIt3j0Gja0gDLTF2O+fK3pLuU472eMeAVGSHUnc1a
	oKDUaWmF9LXUE83mJff5X1w2N2+hfH/r9CA3o1pNvM5NCF1P3lqvFMhplWkrGXrXvav4vz
	Um5RmJw1077t22/dpcag3snUt2wXx6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777903499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4P7MFhSaj3vw5vvBDvqAjWIzIlF+CIm5GapKhhYDCU=;
	b=MRE9VgBvkFA0WNVZf5lPPIz4zhl74tOWlpG4sTrayx/eHuQYlMnECUXAzuxzA8NUXHC64a
	8urI0V3bLIQ8hADA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XN7pbcJu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MRE9VgBv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777903499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4P7MFhSaj3vw5vvBDvqAjWIzIlF+CIm5GapKhhYDCU=;
	b=XN7pbcJuXfdIpp6juuySwcdvcDfBREIt3j0Gja0gDLTF2O+fK3pLuU472eMeAVGSHUnc1a
	oKDUaWmF9LXUE83mJff5X1w2N2+hfH/r9CA3o1pNvM5NCF1P3lqvFMhplWkrGXrXvav4vz
	Um5RmJw1077t22/dpcag3snUt2wXx6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777903499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4P7MFhSaj3vw5vvBDvqAjWIzIlF+CIm5GapKhhYDCU=;
	b=MRE9VgBvkFA0WNVZf5lPPIz4zhl74tOWlpG4sTrayx/eHuQYlMnECUXAzuxzA8NUXHC64a
	8urI0V3bLIQ8hADA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 18/53] objtool/klp: Simplify reloc symbol conversion
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <9572b2e15500e5ed8dcbaac78c966557d3000d85.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <9572b2e15500e5ed8dcbaac78c966557d3000d85.1777575752.git.jpoimboe@kernel.org>
Date: Mon, 04 May 2026 15:04:53 +0100
Message-Id: <177790349308.43444.11115251545125651687.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=564; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=Dcnje7nyZZnn5Ul3fkRGXdjBjdUoLI3iuJ+sB74uYCc=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhswfyzt3mdWozYwSurYwYJ70h6IbHD+aHp6P5Uu8uzZH2
 Pzuoya3TkZ/FgZGDgZLMUWW13ud5Qyn5BpoVr+7CzOIlQlkirRIAwMQsDDw5SbmlRrpGOmZahvq
 GQIZOkYMXJwCMNWmKez/bDc+Kcm9lfbiynyj/sOnowuduutUw+c0fOP9aBt39IulQXyP9iRZ/T0
 xCeZWP9un3tD4KaL+ZsP9SXIpvJxbbBnt9n/4/DHzq8QiDlMjP/7T1nah55IePlWX4uvZdcao78
 bVHx+P/8tPmCscon38RP3vomC+/8kmLGwMmfGx9qEa/qt82TmtY7dZXrT5s5Tj/IWXs5hvVuw3/
 3DP0vT+pGo1phUpfr8U7q+vtfjntS45abaEsf71X9Oag5VD2v5vE+kWyMq/a9KhdEX8xcNPF/mL
 OeamuerwKca7n/7DvXxP/zfT+YrRM6obAp2zDu0sWGfDJVdi9odf9Vts3JueLtHLvaVvc6/knYq
 ctw4A
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.38
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 2FB654BED96
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2696-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.968];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:06 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Inline section_reference_needed() and is_reloc_allowed() into
> convert_reloc_sym() and remove the redundant is_reloc_allowed() check in
> clone_reloc().
> 
> Move the is_sec_sym() checks into the convert callees so they become
> no-ops when the reloc is already in the right format.  This allows
> convert_reloc_sym() to unconditionally dispatch to the right converter
> based on section type.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


