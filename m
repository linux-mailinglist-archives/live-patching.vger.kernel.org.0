Return-Path: <live-patching+bounces-2672-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMSHFA+A9GmXBwIAu9opvQ
	(envelope-from <live-patching+bounces-2672-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:27:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B92EB4ABA1F
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47F83301A40A
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE411387362;
	Fri,  1 May 2026 10:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7CkHTGd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D837DEBB
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631203; cv=none; b=nyyy2FzZTUpKo9dv3hUKQhfS34k405ayLsbSO7Jb5oYe0crj6ETKVhNgyQDK2ucu+2C56e486IOGu3m8wiR3quQ3ivWkooESsXQ+n6+h9JnNdPjDbchCFYs0CV6dFgAzdnTWAu1vqXkjCR+uZ7G6Bx7mAV4oAPZ6kqkgZjqWgNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631203; c=relaxed/simple;
	bh=NEcc7Z9k2sIDq712WZj+8B/yyb2amUdtahDk6sXvqJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=awBVxaohTgIQR5YARY7hxJdATUXSCZwzDHgI4RGLYT5LvuaICHwI1b1zAj3+jaeSYdU3NIvzmmRCCmqoBTKty9eb15nMxA6EunA9rXQbSAbWqvfHeSuc3dudztoeH4waWa1l4q7Z1/NdsEaMPYPynH1xY5tdwCzzxOoZ7WxuOkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7CkHTGd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9392BC2BCC9
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777631203;
	bh=NEcc7Z9k2sIDq712WZj+8B/yyb2amUdtahDk6sXvqJw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=o7CkHTGd5U07elNzPyrqtxgJ94FVhXpIbQraqM21HRqNVlHioLXWZS1ICyCYI+zic
	 SNwCkDsWOZazJ6O+4EUuTOBdwl3vE4d5lxk8p0n/1zzCzuax/XkC9heiMQ9KsGssIr
	 PMgQnybKj83CQevonBuurbIGpEv0MrTiq3BY0jCY6/Tw5SLkMtTUuCSOwBvP93GQqm
	 f6uTODCnKqoH37hNOrlRJaQpWqnYcbNjKo6cX/JMWei1giPwapNKR43tXOiKys49ze
	 SDtkxWxFgx8N+Azug3IW6DA45dUlP14huD8ahSVC5/3P+bPoUrG/wzm60IjszQ018E
	 kb3I2IbmDUfBw==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-506a7bbe9d0so13468481cf.0
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:26:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8S3Ih+qu7MVa4YI10xoeaclJbc78Ap9o6jkNJFQUiWXqUnx/Dmo/ejCXYDDAaGrvYA2B3XIEBb3dtmDXtG@vger.kernel.org
X-Gm-Message-State: AOJu0YwOn5R/zm+N09FytZ4geVNv95KVXd11p5FL2hKnKD9l6iPcdLzy
	16wg5vOhx0lZ0YbBKUHOciKghzNxvg2gvMlKN16p+L1U31dOrcp7ER2kPj+tjbnC6fZXZh19DQb
	KB3cQKAympz1m8AOcqn7F925tnm1XWL4=
X-Received: by 2002:a05:622a:1e93:b0:50d:82db:773e with SMTP id
 d75a77b69052e-5103e947a6dmr33652251cf.47.1777631202603; Fri, 01 May 2026
 03:26:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <8e69c287bd6c33cec1535228e2239b33f4602bc6.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <8e69c287bd6c33cec1535228e2239b33f4602bc6.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:26:28 +0100
X-Gmail-Original-Message-ID: <CAPhsuW7EwgZjuWg6QyXRoJ-ah4m74OKpp9qfqvi-Cfr1s0W=+w@mail.gmail.com>
X-Gm-Features: AVHnY4L9TOGtzdsullb_Bm6V9BvpeiklueyYforyTxUXYxqMK5C5Jlv_xq4hqy0
Message-ID: <CAPhsuW7EwgZjuWg6QyXRoJ-ah4m74OKpp9qfqvi-Cfr1s0W=+w@mail.gmail.com>
Subject: Re: [PATCH v2 03/53] objtool/klp: Don't correlate __ADDRESSABLE() symbols
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B92EB4ABA1F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2672-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:email]

On Fri, May 1, 2026 at 5:08=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Symbols created by __ADDRESSABLE() are only used to convince the
> toolchain not to optimize out the referenced symbol.
>
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

