Return-Path: <live-patching+bounces-1927-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMe5FvqCemnx7AEAu9opvQ
	(envelope-from <live-patching+bounces-1927-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 28 Jan 2026 22:43:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B70B8A92E4
	for <lists+live-patching@lfdr.de>; Wed, 28 Jan 2026 22:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5EC9D3051C97
	for <lists+live-patching@lfdr.de>; Wed, 28 Jan 2026 21:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45503382F9;
	Wed, 28 Jan 2026 21:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEpp2/ui"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A18337BAA
	for <live-patching@vger.kernel.org>; Wed, 28 Jan 2026 21:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769636540; cv=none; b=J7n4OYpY5DtOYBqoO0hQKf3GUTfxK7lThCRuzFIoUr57XjsJiWrSocd06s2aduFql9nnS6XT08SJnEF3Pk2EWAse4WrK2KVYR4qocAZtmijoJ6wC/ZxQA6STnc0BC2SgfjsWc33r61LRkR+T5r5ZMHUYm8ogk+/lDdvyLWqKAM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769636540; c=relaxed/simple;
	bh=4KkWZRGPtUM+1DKD9WwkwvF1bBoEnFFOeTodO1jcK1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ix/xEavmXh/8AqRQuunRyg1LU3twanXrolXgOYhv4JdZnAusoecPSg1HS4YJ9W0wFOzqj9rzaCVLxCApl2isvRNRlNH6h7BRbczEB0CBpxXDh4/j1dshD6MC49lgzcr5R065w08Ai9RKpvRw17pLafblUBB2AcVDOH2+BZ3n7nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEpp2/ui; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662ECC116C6
	for <live-patching@vger.kernel.org>; Wed, 28 Jan 2026 21:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769636540;
	bh=4KkWZRGPtUM+1DKD9WwkwvF1bBoEnFFOeTodO1jcK1o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vEpp2/uiQFoOxI03D0img9RuPrcb20m1iHFX/OKP0CTmXCu3IGrh3JvGx9NLTvqmo
	 oJj4HvKW828PxpXi/tAlo2IMfPtnT5jbf2oigZD8XrP8SdFay34PPUn5JwYuhUUh1I
	 QKq5bMqh2t2K3/O5nliQ9T/3NIPcDFF2dDXF7asSZ7LsPlZQBkovRwsu905B6txjav
	 AWWUN2QuvoSaYY+UHuhqyONTJxOUyef68NDv+NyHOrskiqm7c9I22QAT2KwArebokB
	 rHMGUlEE8H00HfLJG8n/LCTJxib3gLm/AfM51ixM7GPWRBAgmZqXXNzS9fSIn3Z7GE
	 AIVX0pNwtEGBw==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8947ddce09fso3205666d6.3
        for <live-patching@vger.kernel.org>; Wed, 28 Jan 2026 13:42:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVqHhqmh+m5ilxFfhFcFpfkFztrYRHftCErJK+ygkOi0wc6yE+OmDF5lK3qWzJKIOkOZhzHOVSRpn4a8b8s@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1Gq0TdhWI8Ub/jMiXFcYePF2i0PyfaTDusUeqZE5hZk531Xki
	wbDp8GFGA7+tdfgj/FCBgB+7uu7BrpcUdZ32edCutgLH9WM5rIBzXUAz1kdsSPLtD93sbxdDqKM
	SIctS/9FAD9+tEv62Y9B+I8sh/fQpkG8=
X-Received: by 2002:a05:6214:234c:b0:88e:c723:6f7d with SMTP id
 6a1803df08f44-894cc8c93e5mr95719336d6.34.1769636539506; Wed, 28 Jan 2026
 13:42:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <957fd52e375d0e2cfa3ac729160da995084a7f5e.1769562556.git.jpoimboe@kernel.org>
In-Reply-To: <957fd52e375d0e2cfa3ac729160da995084a7f5e.1769562556.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 28 Jan 2026 13:42:08 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7SLub_KhK-eqtj3qJMuKRBnQng60GG5kvkS2FxPjC78A@mail.gmail.com>
X-Gm-Features: AZwV_QhZMPRU1Rs1HfVjEEhI3BKxhiph_6s3XbyrKHYRmfaJbTsNAq9rzzYRubw
Message-ID: <CAPhsuW7SLub_KhK-eqtj3qJMuKRBnQng60GG5kvkS2FxPjC78A@mail.gmail.com>
Subject: Re: [PATCH] livepatch/klp-build: Require Clang assembler >= 20
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
	Puranjay Mohan <puranjay@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1927-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B70B8A92E4
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 5:12=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Some special sections specify their ELF section entsize, for example:
>
>   .pushsection section, "M", @progbits, 8
>
> The entsize (8 in this example) is needed by objtool klp-diff for
> extracting individual entries.
>
> Clang assembler versions older than 20 silently ignore the above
> construct and set entsize to 0, resulting in the following error:
>
>   .discard.annotate_data: missing special section entsize or annotations
>
> Add a klp-build check to prevent the use of Clang assembler versions
> prior to 20.
>
> Fixes: 24ebfcd65a87 ("livepatch/klp-build: Introduce klp-build script for=
 generating livepatch modules")
> Reported-by: Song Liu <song@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

