Return-Path: <live-patching+bounces-2705-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLIwMVG8+WmTCwMAu9opvQ
	(envelope-from <live-patching+bounces-2705-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 11:45:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D494CA0CE
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 11:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4933B3011BC0
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 09:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250E8330315;
	Tue,  5 May 2026 09:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ozXHgS7S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4hLvRZz8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u8lVt5zy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pbyj33IE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBFB2D73A0
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 09:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974263; cv=none; b=a4vTu+vva3eaYMl7TGp4DUvRhxzmw6LsiNIwA+SPW5u2GBLIIiEe3sAUxAFq4S01QHAH1jw/rCduR5mqGygQN2ov8KDYUaX590gY3XStEBwOYCmM+Y9kgisNTW8BkIIajuoK/a0RxngH9CsB9tTmHIsZnqBRh7EvJ5NomK9O3GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974263; c=relaxed/simple;
	bh=LVWdGKY9NSjBpxic5j51mCbVSub/0OPBIzEn9Tu3WQI=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=flffMFVDyN10CRcrEr9kpfFFOxwA0t2ntjpn32zB+xARxX4tf+ItlfLCJQgHQB/xT1kesTzzFmpXoGPGVRG67Mk7qMYKeryW+woR5qLLfXJch6uJViyYV2Ent02VNrOBGEUV577+XM8g1E6gzGSl1d066fT97ZHCAHv1intiuok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ozXHgS7S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4hLvRZz8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u8lVt5zy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pbyj33IE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0BA0E5BEF8;
	Tue,  5 May 2026 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777974259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6oet8NeVMJn3gC6kbYHcdpV6J5HHq40163o8NLFLmM=;
	b=ozXHgS7SJU97rbfLpTDAUPUqRdhUWkTXo0j9MGiDgEvZstPw8Mh69cPMimB/wmIStA2rUE
	7ckqUBThC5pCgNoDWWILX1UDfVyKnMEZ7YRmg3++LtTDx05HBcoMSaNyIbmL10AKf4UvT9
	hT1tKu+i8MHDEWZQb4dH2sC8va2FyLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777974259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6oet8NeVMJn3gC6kbYHcdpV6J5HHq40163o8NLFLmM=;
	b=4hLvRZz8ZHleUfQP5BfI2PU/Y6R4rUGZYSdaS0ExHcEGNneOznmA3KsxCi/Fr62gaFSKxx
	Y89cpWgT32bvW9Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u8lVt5zy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pbyj33IE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777974258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6oet8NeVMJn3gC6kbYHcdpV6J5HHq40163o8NLFLmM=;
	b=u8lVt5zy0LUYqUDqpKwOwJyC5tZd4m2SaTPVIWT4iw+KAnlL3z4b2Z83XkAquV/460JMY+
	OBNsbteIYiq/48FyhdYnKvmCpWyVrGUqKDIbFHn5iMeWvBQhwbqIP7+V8dpW2rbiiGrYUJ
	k0314zl/XEfePOoXFgM3xDpLlQgmi7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777974258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6oet8NeVMJn3gC6kbYHcdpV6J5HHq40163o8NLFLmM=;
	b=pbyj33IEk1ToM35GNtaKmpEvVIpmf01NIUMkCrU2Q45Uj3fM96o+TaX8LDv/xFtwEU6ZgW
	icSYdEz7C68+1LCQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 19/53] objtool/klp: Fix pointer comparisons for
 rodata objects
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <07de8098fd8981321baab0ff552f65aa2cfc31ec.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <07de8098fd8981321baab0ff552f65aa2cfc31ec.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 11:44:14 +0200
Message-Id: <177797425477.9921.11351979996126617832.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=488; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=LVWdGKY9NSjBpxic5j51mCbVSub/0OPBIzEn9Tu3WQI=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyfuz/KpdqIrgpd8GRt936918/a9S68MOBbtchlVue1/
 VeS19kEdTL6szAwcjBYiimyvN7rLGc4JddAs/rdXZhBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKm+P4P9n+IXZ457CopnzJ6YJBQoKVjEfV8ssmKL1+aJmost1L33xZsLJ92IO+t
 UWZile/XFu59lPYlrE775Gi5yWJ1yzzj5u0L/VXEX5rqs2YVfvb5J7Ph17W2xv/Gyl5fW3V9Qs/
 bsrQXZeW0yO/Y57160mnsRyxvdwAdNJ5cwX0kqvVq66g5b9qR/XI6XglcVPn+mM/1B8tWtc3Xrr
 hVacSfuOLxospeLUem0Ka7BT7MebWRcrMmnn2OQnpxuz+q07mSr2zKlHXZ6/1/FlrEvOqMzM2ql
 4arGlqVnBAXl34uutU06KXnOd6Nc+vmFTFfZ/7Osue8h5tKYtjPlydntH6za1837KXHfMtSh6/i
 7CXGX4gA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 18.89
X-Spam-Level: ******************
X-Rspamd-Queue-Id: 66D494CA0CE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2705-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:08:07 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> klp-diff treats all rodata as uncorrelated, so any reference to it uses
> a duplicated copy rather than using a KLP reloc.
> 
> For the contents of the data itself, a duplicated copy is fine.
> However, pointer comparisons (e.g., f->f_op == &foo_ops) are broken.
> 
> Fix it by correlating non-anonymous rodata objects.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


