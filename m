Return-Path: <live-patching+bounces-1966-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDjnFkYegWm0EAMAu9opvQ
	(envelope-from <live-patching+bounces-1966-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 22:59:34 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B08B4D1E7B
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 22:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0475D3018BC1
	for <lists+live-patching@lfdr.de>; Mon,  2 Feb 2026 21:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6876D318EE0;
	Mon,  2 Feb 2026 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qs89bqHA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575D318BB2
	for <live-patching@vger.kernel.org>; Mon,  2 Feb 2026 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770069566; cv=none; b=sERpuqqItNN3X5lMnwmlm5i7nUQybA+CGhZXOPRi6AkJeghYlaeltjwu8nvsgK+l9dNYGdJhkBkyYSK2DoEcUiDCObcWL6CVWVGxpx5lhdU8hv1XI2nwYdE/rwyvuCQ7EgNJ2dFic8j34ThOpmre9AghbThCfHEAJxV/Hw5hnyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770069566; c=relaxed/simple;
	bh=83293i7jcnUcVkBVW7it3OvjhcrYUca8CHdxEre9tmM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ioCViLXkYynNlB7EAoW0XzUtdWozgnWtBWIhh81b0IsYIHlih3czXhHwp2CuXUAaFlN/q8nyRxYCBQBwxlWoBAnnA9v2F4GLBMNX9OSAFA78mgwUbfauaMs1lNKkfpXU1YfeijIfD6xyyilmx3h76QYVNHU4SU3qWsOqRLy/HME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qs89bqHA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9176C2BC86
	for <live-patching@vger.kernel.org>; Mon,  2 Feb 2026 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770069565;
	bh=83293i7jcnUcVkBVW7it3OvjhcrYUca8CHdxEre9tmM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qs89bqHApGWMQWM05OZ3fYAPoREMCbSm4H62hMwUJqJPWMHPHouzD+KjZ6PxdwhKa
	 z2ocbQUUNrnebG5pRQlF64o60r0r5rYhrVZd5gt5FV61oTyTVBkF7gG5SvlYKkhdD4
	 jI0Kd8iHu5tYerTfm+RqXbTV3STU3+zrGLyP92ZidOTJZDNx3+3G0tALGLntoWWyhK
	 umeU2FRlLerws/NYiOr0/UTxwW4oWWynLqjovSUkqjIQYGRsXym9fwM3eJbJwSf9ji
	 mx87XtcXJDhWYIqMkRNWntk6RPnAKHyZkSvCmjUaugMHRtv9TW0rVRSVd1zbhaq0/i
	 i1nc6P+9IN43w==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8c6a0702b86so507724085a.0
        for <live-patching@vger.kernel.org>; Mon, 02 Feb 2026 13:59:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWKGmU0vfkvZV++YOa8zKR6RICA9fhnfDMNXUHZlSFLpZ8yK2TtsSIDQjY6DhK2n2LRV64Id3XEMjINUWXq@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3A17b13u666+bjQHGLEXC0GP3j55XmQh+7zvOK6rQriMf3UwY
	xEiWSFq8fZRoZnfvV2R8NrYpc5e3DGpTnfJbtk9Txphdg/0JIrMc3ESz/TNMCC6B6FQchnl2UAX
	G0+aHV+b4AWSzP8blG94/0fwCu8MvXNk=
X-Received: by 2002:a05:620a:440b:b0:8a4:107a:6772 with SMTP id
 af79cd13be357-8c9eb32dfc5mr1687381585a.76.1770069565051; Mon, 02 Feb 2026
 13:59:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0bd3ae9a53c3d743417fe842b740a7720e2bcd1c.1770058775.git.jpoimboe@kernel.org>
In-Reply-To: <0bd3ae9a53c3d743417fe842b740a7720e2bcd1c.1770058775.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 2 Feb 2026 13:59:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7HDdwSdvNzVMtTPrJp=96coaLttU4p4szmF19beTzKnQ@mail.gmail.com>
X-Gm-Features: AZwV_QiGwRQ-4tdr5_P3YKfSqoCVqhT_35PcGn7uUVIHntvQmHSaqDGTmJgR3Vo
Message-ID: <CAPhsuW7HDdwSdvNzVMtTPrJp=96coaLttU4p4szmF19beTzKnQ@mail.gmail.com>
Subject: Re: [PATCH] objtool/klp: Fix unexported static call key access for
 manually built livepatch modules
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Arnd Bergmann <arnd@arndb.de>
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
	TAGGED_FROM(0.00)[bounces-1966-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arndb.de:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B08B4D1E7B
X-Rspamd-Action: no action

On Mon, Feb 2, 2026 at 11:00=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Enabling CONFIG_MEM_ALLOC_PROFILING_DEBUG with CONFIG_SAMPLE_LIVEPATCH
> results in the following error:
>
>   samples/livepatch/livepatch-shadow-fix1.o: error: objtool: static_call:=
 can't find static_call_key symbol: __SCK__WARN_trap
>
> This is caused an extra file->klp sanity check which was added by commit
> 164c9201e1da ("objtool: Add base objtool support for livepatch
> modules").  That check was intended to ensure that livepatch modules
> built with klp-build always have full access to their static call keys.
>
> However, it failed to account for the fact that manually built livepatch
> modules (i.e., not built with klp-build) might need access to unexported
> static call keys, for which read-only access is typically allowed for
> modules.
>
> While the livepatch-shadow-fix1 module doesn't explicitly use any static
> calls, it does have a memory allocation, which can cause
> CONFIG_MEM_ALLOC_PROFILING_DEBUG to insert a WARN() call.  And WARN() is
> now an unexported static call as of commit 860238af7a33 ("x86_64/bug:
> Inline the UD1").
>
> Fix it by removing the overzealous file->klp check, restoring the
> original behavior for manually built livepatch modules.
>
> Fixes: 164c9201e1da ("objtool: Add base objtool support for livepatch mod=
ules")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

