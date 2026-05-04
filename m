Return-Path: <live-patching+bounces-2694-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NPUE2Oo+GlexgIAu9opvQ
	(envelope-from <live-patching+bounces-2694-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 16:08:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 683694BE99D
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 16:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4BF723005171
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 14:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070493DDDDE;
	Mon,  4 May 2026 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2zVi1cpP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cHZFrZWT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2zVi1cpP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cHZFrZWT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969732BFC7B
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903198; cv=none; b=Ziw6pOxnRga9UO0COSbJs8vEPypQ8XnBgVVGz42rKFV5ZCW+oSIja3lLB99dMw5sCgqSQFzX9E5+rXe7juAA8Mo0Qx+J2PQMCCxNbx6GHIR3dKCEoMk4q7qF9R6C4BxJc+6Kf/h9vDX8w/QWagUdZ4QNaHb1O/1okkVyTqrE618=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903198; c=relaxed/simple;
	bh=0kCxmN3Vun+kt7KYIkqBSE35LNKBnb3SRgdirKU2Sdc=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=KOAalpTZHhkEv8FY7CJDzJxuVhfGHpjcLjf9CryWJRg5EFk2QVUIQXdidJAGbO2KDXmnSrrzQHgAuTxvYc7yleewl3SkCIT15/NdZPESVXrsc1waqKuQ4gk1TC5bXErc1NoyFhaMpGnIQzMB1x45eAtDWbkB7YOsIh/L5e6hbjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2zVi1cpP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cHZFrZWT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2zVi1cpP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cHZFrZWT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:2b::1244])
	by smtp-out1.suse.de (Postfix) with ESMTP id 5FADE6B27E;
	Mon,  4 May 2026 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777903195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+l5HhEp8Ua6Xdwwjd6TnXKQMkrF6AwxCBdY156Y9Ls=;
	b=2zVi1cpP4KzbJqQMh3M0b/EkWhy+upzfCHo6j95zILf/TYX3TuzM3FbCscWdmGLJmHbyHL
	ZoB+EeBLI8Tbzz9am7gyPjlqjQrLrthS/+3NB5NURR7XGnThznu6ON0QeDz/e83elJteoH
	TUXpQQmXSFfCsmDp5q0GUetXwzQww9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777903195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+l5HhEp8Ua6Xdwwjd6TnXKQMkrF6AwxCBdY156Y9Ls=;
	b=cHZFrZWTVhfS0S1HEkI/FSDM91r6hVw7hOOjI7eAHy7wjw3gbM8VG3Fg2gxr67jLupngP7
	Q+iVOOkCIyYOlEAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2zVi1cpP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cHZFrZWT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777903195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+l5HhEp8Ua6Xdwwjd6TnXKQMkrF6AwxCBdY156Y9Ls=;
	b=2zVi1cpP4KzbJqQMh3M0b/EkWhy+upzfCHo6j95zILf/TYX3TuzM3FbCscWdmGLJmHbyHL
	ZoB+EeBLI8Tbzz9am7gyPjlqjQrLrthS/+3NB5NURR7XGnThznu6ON0QeDz/e83elJteoH
	TUXpQQmXSFfCsmDp5q0GUetXwzQww9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777903195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+l5HhEp8Ua6Xdwwjd6TnXKQMkrF6AwxCBdY156Y9Ls=;
	b=cHZFrZWTVhfS0S1HEkI/FSDM91r6hVw7hOOjI7eAHy7wjw3gbM8VG3Fg2gxr67jLupngP7
	Q+iVOOkCIyYOlEAA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 09/53] objtool: Replace iterator callback with
 for_each_sym_by_mangled_name()
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <cb95eae9cc63ca04f881c69c93eed6bac0c751fe.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <cb95eae9cc63ca04f881c69c93eed6bac0c751fe.1777575752.git.jpoimboe@kernel.org>
Date: Mon, 04 May 2026 14:59:48 +0100
Message-Id: <177790318863.42744.11741644284979798465.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=357; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=0kCxmN3Vun+kt7KYIkqBSE35LNKBnb3SRgdirKU2Sdc=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhswfy8L95Y7U2/feX3Yz/PvXXY7zHnSd6Pc+57N4sUuwy
 bnGm3dudDL6szAwcjBYiimyvN7rLGc4JddAs/rdXZhBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKnmLWL/p/J9+b5Jc/kMWh2ttqzdnhsZ137swNYd7KHzbj/eMMmQ74rNAs0oK47
 b939rHlrAMaP37GquG1Xm1j7BpSLLj5h6JOV+vjZlR194o6kbf7ADvzx/T8bS8xdzPm9YfLAusH
 LSlr/am+Mq/O90srD+2O3/IPlRlvI0w0DF3Y5JnE8UQ5XPXJBqW8mf8Jl3t+4nx52Tnk/Wav15Q
 MHqT6Hsxl+MQo03e++cFy5I0JhWv3Ga/IqP0l/ONO6Tbm3VKsr2+/Ao/wpj8TpLlfuWDveqVnzs
 fT+3h2fus9N7mq3zdrN+dltpVcM7uVC3+NGpjY6PVD9JmJvevvf46q6v36+66FwwZfm0JjJ1R1f
 gDJYZMQA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.50
X-Spam-Level: *****************
X-Rspamd-Queue-Id: 683694BE99D
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
	TAGGED_FROM(0.00)[bounces-2694-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.968];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:07:57 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Convert the callback-based iterate_sym_by_demangled_name() with a new
> for_each_sym_by_demangled_name() macro.  This eliminates the callback
> struct/function and makes the code more compact and readable.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


