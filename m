Return-Path: <live-patching+bounces-2005-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eMW7AQvJi2kwbAAAu9opvQ
	(envelope-from <live-patching+bounces-2005-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 11 Feb 2026 01:10:51 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1211203D8
	for <lists+live-patching@lfdr.de>; Wed, 11 Feb 2026 01:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF860304302D
	for <lists+live-patching@lfdr.de>; Wed, 11 Feb 2026 00:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9733207;
	Wed, 11 Feb 2026 00:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAf4TUUu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B4E3FEF
	for <live-patching@vger.kernel.org>; Wed, 11 Feb 2026 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770768648; cv=none; b=T3m1eCe0ay9CcjwURpPlozqwCm0O8ZY8uvZJcnRuaztbspSIedL9Axhxv/hdYYJ1olFHabEbVDnqAxJkNohdCkvbbgcTI1bJ0kLLlmaEOqt4jcX5Asf6wpRnur19EGOjS43N/bm5zgSJNyt+ZAekjDArDf3l+fVX3ybbpu/0hWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770768648; c=relaxed/simple;
	bh=PwjZHGcIs8Qzpzk/MQatYxcchlK3nPVhNRVa4tCkhqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X2BPI+TEA7KRN9V5muw3IN24XiFvDnxcjvdnwltn7r+0aoXg0ThFFTyug5uEnS2fU7FQqjDiie78tj1c5N9d39oc1uaCe8wn06V05i8MHHV84Ryg/VZXks8eKj3cYzXCBkc2K4kfiYIl4tRv4CW/psKG987v8+D+59UvudLnm18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAf4TUUu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEE5C19425
	for <live-patching@vger.kernel.org>; Wed, 11 Feb 2026 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770768647;
	bh=PwjZHGcIs8Qzpzk/MQatYxcchlK3nPVhNRVa4tCkhqo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MAf4TUUu4rapwZpMYxxGXgXFpChauTB0T4PJwATOvW0dzdKjrpPCyYNV9K4VINuhY
	 FRDFow4ZcuBEzgxAtZ7h/2tDKw5PQNyPD/Tj5ps2gChxCiB9C7zjp+wyDkNO1QljeL
	 V18d/165BpaqDhJiqhq8iM5IQHb/uGV8iqXzWn/v2xX2Wln2OH3OlZ9WIqJXkZ8fVL
	 qs/vDrHcV34ixU5JG+AAz8zSAMS7ORxt/kB8Jj+47RJVCjlrjxOzK1nOyhx8DZwfIx
	 fi8kpq+m7brkaEX9q5qONyFJV3NqtXRuvgikzRk29WwJk8PbryjHyTrkICnePNoZKj
	 Bhpta+tawOsMg==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cb20bcff5aso113788785a.3
        for <live-patching@vger.kernel.org>; Tue, 10 Feb 2026 16:10:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWUwLPuA/U5BpTCL1bWYOcrBP9uTBXpi/NLllFVamQzK5sGPu48aouexJgWtT1pe2uq2z4njrozQZdx0IYy@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi0D3hIcvVCWFEWy/Nf/SGJuCZNFwDxjhH3EYUoNn2t+PTnff4
	YePFCq6Yx8LUoRrAqoIT5l8I0fknnjC4I3et1130MDVSkMW86mjXczDcV+mkS0/+S+qgNY9/5rH
	CXjdBu96+2/u3iomMdeVl19mX0AZYGP4=
X-Received: by 2002:a05:620a:480b:b0:8c7:1106:1a44 with SMTP id
 af79cd13be357-8cb1f72e35amr514143985a.79.1770768646922; Tue, 10 Feb 2026
 16:10:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770759954.git.jpoimboe@kernel.org>
In-Reply-To: <cover.1770759954.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Tue, 10 Feb 2026 16:10:35 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4DsTHn_zqpHGPTaRL1aOsbcqugyDF11pyQuD8dLencRQ@mail.gmail.com>
X-Gm-Features: AZwV_QgJPnHipYsBLRukC9X-XYpMjA5LO4JqzrUD7zgazzmaav-Wseina3-fZuM
Message-ID: <CAPhsuW4DsTHn_zqpHGPTaRL1aOsbcqugyDF11pyQuD8dLencRQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] objtool/klp: Special section validation fixes
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org, 
	Joe Lawrence <joe.lawrence@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2005-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5F1211203D8
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 1:50=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Fix some issues in validate_special_section_klp_reloc().
>
> Josh Poimboeuf (3):
>   objtool/klp: Fix detection of corrupt static branch/call entries
>   objtool/klp: Disable unsupported pr_debug() usage
>   objtool/klp: Avoid NULL pointer dereference when printing code symbol
>     name

For the set

Reviewed-and-tested-by: Song Liu <song@kernel.org>

>
>  tools/objtool/klp-diff.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
>
> --
> 2.53.0
>

