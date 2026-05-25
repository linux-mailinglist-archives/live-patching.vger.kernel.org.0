Return-Path: <live-patching+bounces-2884-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6NPpBACYE2qyDwcAu9opvQ
	(envelope-from <live-patching+bounces-2884-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 02:29:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CF95C5072
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 02:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 155763001FBB
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 00:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59C61B3B19;
	Mon, 25 May 2026 00:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eahBUstE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B2164A9D;
	Mon, 25 May 2026 00:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779668984; cv=none; b=j7FX2oTEUD6rEGGkHrw/bd81GzQn8R4P9zIT4JjMLFSgOYSQ66aSJS+bEpXDnGpOHD3iEATfiuBIIgGvCVzkZnx3VtCLsOjpb3N7dkDjtUJHUAo/Uq8WdrIr0P8aVUoioeg+Mt6ZbWwZqpjcWWeQplg1jj40yyFDz8nJ2I77ohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779668984; c=relaxed/simple;
	bh=Qoxj9vzxkk7qVf1ZYlS82Hr9skoAVvLaDZc5If5HiK0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kecOLPdzSxz5BvRHtLri3P7WpH8OqJKqRKnEGjQ37ktzvmCYy5rW8xV+/g/WHXIM4TJbMbRclqGr5bmOg3VWqtQk3fmx9yTzI35EjhNIcsmT6oR+CHJpPJ7QwYzPAobvzf68lT0n74k9Pxz4wJJ5IR3FO5cYxQKnsMlJvaqHs7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eahBUstE; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1581F000E9;
	Mon, 25 May 2026 00:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779668983;
	bh=+0la3+a1/SfXT05O5t+8D92DVzm5jvZ6Ee5NFqbA31g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eahBUstE7YWCRe5itSf6PKisDW58q2zaRelFaRX/Hdxq0WcLv0Dl0gPu9jtTCDtR+
	 89jVTjUJwDm/yCTwCzlhcwCjO3Z1AGcBMRTSGxjnuLYzRkF864vXKmu6zRVo9lbQYJ
	 okBgmT/XQyO4dRpybXn7k28gmZUqYVXDF8VZMUkuxBrn/r2W9Pod2DHTKA4I9HtuzC
	 0xe4cEhAaUAJTa4fe7p80zKfb/0hd+zMT+fWiJc++vNJ1kpvbhgRFEbC/gs4Mwr+rQ
	 1YPSdCGV36oA6nopNZx2kw/matboECHwSfEZMEtZkFh0VKeRdjqKPdMqlC2ipUE57u
	 Sn2I5Gpqr/sZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] selftests: livepatch: Add information about minimum
 kernel support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miroslav Benes" <mbenes@suse.cz>, "Jiri Kosina" <jikos@kernel.org>, "Shuah
 Khan" <shuah@kernel.org>, "Josh Poimboeuf" <jpoimboe@kernel.org>, "Petr
 Mladek" <pmladek@suse.com>, "Joe Lawrence" <joe.lawrence@redhat.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, "Marcos
 Paulo de Souza" <mpdesouza@suse.com>, marcos@mpdesouza.com
In-Reply-To: <20260524-livepatch-unload-on-fail-v1-4-7465de7f741d@suse.com>
References: <20260524-livepatch-unload-on-fail-v1-4-7465de7f741d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 25 May 2026 00:29:42 +0000
Message-Id: <20260525002942.9D1581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2884-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,sashiko.dev:url,smtp.kernel.org:mid,lists.linux.dev:replyto]
X-Rspamd-Queue-Id: 14CF95C5072
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Mandating backward compatibility with an ancient kernel version =
(4.12) for all new in-tree selftests violates established upstream kernel p=
rinciples.
--

commit 005a4d6b98d5e0ddf7ab7d595575364d010c4d3f
Author: Marcos Paulo de Souza <mpdesouza@suse.com>

selftests: livepatch: Add information about minimum kernel support

This commit adds a note to the livepatch selftests README. It documents that
the current tests are compatible with kernel 4.12 and mandates that all new
tests must maintain this backward compatibility.

> diff --git a/tools/testing/selftests/livepatch/README b/tools/testing/sel=
ftests/livepatch/README
> index d2035dd64a2be..293f4730b9277 100644
> --- a/tools/testing/selftests/livepatch/README
> +++ b/tools/testing/selftests/livepatch/README
> @@ -54,3 +54,6 @@ check_result().  The latter function greps the kernel's=
 ring buffer for
>  those strings for result comparison.  Other utility functions include
>  general module loading and livepatch loading helpers (waiting for patch
>  transitions, sysfs entries, etc.)
> +
> +All new tests and test modules MUST be compatible with kernel version 4.=
12 and
> +later, including current upstream kernels.

[Severity: Medium]
Does mandating backward compatibility with kernel 4.12 for all new tests
conflict with upstream kernel principles?

Requiring tests to support an older kernel could block the introduction of
tests for any livepatch features developed after 4.12, as the required
internal APIs would not exist. This might also force developers to clutter
the test module codebase with version checks for old kernels.

Should the burden of backporting tests to older enterprise kernels be left
to downstream distributions rather than enforced on upstream contributors?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260524-livepatch-=
unload-on-fail-v1-0-7465de7f741d@suse.com?part=3D4

