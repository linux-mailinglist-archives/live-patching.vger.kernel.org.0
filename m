Return-Path: <live-patching+bounces-2068-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cC6rEIKEnGm7IwQAu9opvQ
	(envelope-from <live-patching+bounces-2068-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 17:46:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9420717A17A
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 17:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B07A322173A
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 16:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CB831AF1E;
	Mon, 23 Feb 2026 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYEM/4Ds"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D667831B107
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864658; cv=none; b=iNXLJyNa9GHh2qcfTg/LmVCyHlHxKftrMGnHAGLM4GSi2uzyMUMYW8YD6E1v7g6PAOysSLbI6cekgIyykry/Ee3aaJok50x7CRfhXQwGLnHva7qln0jtDQIeIMl2Z9P3aLLW7jxx4tL+Fv2eH6NBlhTkNFH6ZzpraauVfiHZkLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864658; c=relaxed/simple;
	bh=pOvqQ22sJSYPUeX0jI6hwPpaMIwAs84Nv/JAu3rmJlA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oytI2mtcWUvKS/oqxmvMDKhbYFTmmxhAXkirh4N83Y7eHUli/bxXkUpXo1KOV4n8eOaQJMgvkpBShYAYsi1AQ0e+AF2zz9y3/2audWF8d1oFBnZkmrv/5LdJ0ARC7Htbpq9rw/YGoxE67ao34v1d4nbb9uqvbhCEnj9b9bSIuyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYEM/4Ds; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48379a42f76so35335375e9.0
        for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 08:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771864655; x=1772469455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWEvoxhzZBj6+mSn7egBTjz7dht5us/wSG/zeGRKBew=;
        b=OYEM/4DsFff8xMNVhiJ86YpLYCE8WpO5dnsOpqHgnyNvp2nh+qBHpUjvXR3aVrI2PI
         IzVKnEH+pFPn6h5ixeh93nH8E07AsAYJXoz4tq5BvU4I+qPqvMrTQ4rvao8nkHKixKVq
         GgEmyl4zjov9nEKgwPJC5LT0o3nYlx8tU+dKe1LEUC6eD+kOiQ7wHK273WI4sEftf85B
         jJQIeEFiKd6xOIR8kj6gNS92HifNY5z2oz2uyknMGXangJRCooUFCxe1BaT+zVDZLO0G
         Wz7TxZTRv593YGT+Akf1WYvZx5i0f0ifm58NeE19rDMCq+gz54Y61fPyJeWdl6EyF5NI
         vKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771864655; x=1772469455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cWEvoxhzZBj6+mSn7egBTjz7dht5us/wSG/zeGRKBew=;
        b=CjGUBzm3i76ZJQp9/UxIcQZHDeXV+/vO0pZJCyTOy8eUyWB7jJEo1jMfpZmoIPEauw
         U5nc73KG/WuPbQZC8nskOrW0Mvxp0VJMWK+zlRmb4bWMTi3GjutsHS1rziUDbhVbPJt/
         WVZxAq9RpAourcqWgQtzeUB0bGro7NdTzLDSV+AfvGeeYu4m/6bBquB1uaBKvRMdtUX5
         /d3rLXGfZwoGG5c2wL5glUPY6RIpBwIB4+Mp+CbtPkB1tlpZxDU8e4bJS9jgKQNfOzYg
         W0IaaUsvQj5NDaRPYLAkNuEqLxJDc6f1qpfVAw1TixosR7YElAbrNE7P+u+1KxFjQDZ7
         auTw==
X-Forwarded-Encrypted: i=1; AJvYcCWEDpo9oGi9Sgzs6GVwieLnUjsMthZhB1rsKYxaGlhZhWdNSZMPXyAryyQmivJDNi07OHIX27iCjLdYl4TL@vger.kernel.org
X-Gm-Message-State: AOJu0YxYH7qWQLSyJr8gMPpynYjvDXr5Do1mZ1XvfO7f3R0uVNSpAd3K
	Ea2CECP2N25T0P1vVqdjeRJ9vV8bN+iVnMvgnee5b1XAiKz0G+KZU96J
X-Gm-Gg: AZuq6aK2qgN6Ki2GCfrmt5n5hQcS4Knecp34Dvygi51R/eJGXvE0rKXyYfPnc/cC9us
	o0obK8jAt1YKsAL2fhEgr2aBQXljqIQ9da5EjQmlGvubQ5ya8McfF/ykNkCa24Hu7mg/moYyI9I
	10s7fCY3aW7o21X2hET7ElpMQvdcNk04L7T5bEmJ8THaPn38DNJ3gho0gvw7CDiZ6eTGO6d9mOP
	ZPhGpF5Xh3qsgjK3mheXKv33xluT+UA4zIathaGlRadUJffphqjM8MhRrx40TdLpOq6td+dMIah
	fgmap5vSD2NjI+a4A2q01WeP9wBf+ETgtZ8SX7JcJ0FsVUvmdfUFqd3BFX5f0rlMIMfh629Ia/P
	sOntOcdjm6mJnhDsfPotbaJN67m28bZB29silLFMJq/a73OHDYQvvKwd1+VyLEwFoZD03woi/aZ
	TBdX/Qs2Qfw8wlbT70Qt5D+uC3TShNLYCrMtOwvDhyHrmBJ1Adrajmdvm6RTom5xW8
X-Received: by 2002:a05:600c:1e0f:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-483afea0266mr76340835e9.19.1771864655120;
        Mon, 23 Feb 2026 08:37:35 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31b3dd7sm285500355e9.2.2026.02.23.08.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:37:34 -0800 (PST)
Date: Mon, 23 Feb 2026 16:37:33 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe
 Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>,
 live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
Message-ID: <20260223163733.00e23e47@pumpkin>
In-Reply-To: <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
	<20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2068-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Queue-Id: 9420717A17A
X-Rspamd-Action: no action

On Fri, 20 Feb 2026 11:12:34 -0300
Marcos Paulo de Souza <mpdesouza@suse.com> wrote:

> When running current selftests on older distributions like SLE12-SP5 that
> contains an older bash trips over heredoc. Convert it to plain echo
> calls, which ends up with the same result.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/functions.sh | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 8ec0cb64ad94..45ed04c6296e 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -96,10 +96,8 @@ function pop_config() {
>  }
>  
>  function set_dynamic_debug() {
> -        cat <<-EOF > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
> -		file kernel/livepatch/* +p
> -		func klp_try_switch_task -p
> -		EOF
> +	echo "file kernel/livepatch/* +p" > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
> +	echo "func klp_try_switch_task -p" > "$SYSFS_DEBUG_DIR/dynamic_debug/control"

Use printf so you can write both lines in one command.

	David

>  }
>  
>  function set_ftrace_enabled() {
> 


