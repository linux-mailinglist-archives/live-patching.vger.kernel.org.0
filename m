Return-Path: <live-patching+bounces-2882-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CK/xM4eSE2ofDgcAu9opvQ
	(envelope-from <live-patching+bounces-2882-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 02:06:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD4F5C4FBE
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 02:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4096930073D2
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 00:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E8B3B1BD;
	Mon, 25 May 2026 00:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nm7JD8Su"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD61EA84;
	Mon, 25 May 2026 00:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779667585; cv=none; b=AjQHVd8YehncveFA93fqQKSuXiNajxitu6EdqB3syvXvGDfk1EbB/BY8KDPfaZe+IBME8a4ugDVPg/1nXbcJoBC34FKVk/n2oBL9zZ/zKBaZlI2ZbM1etcW0xFX0562keVxqbfM2hm7v/wdiiqsGLvO/bmT3d7+YyFeSWXSqeOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779667585; c=relaxed/simple;
	bh=jJRZTqf9JGzaEBxOWLXcB7e9r+vbN7SX71HA7uxULa0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rOjHne5gI9FIkY4eZ9IFNWKdW7Fb6tqdAJkmIj92VyrWuBRxRZzkRT0lBzRtdVD21YFOZSKj5jr3e8/fw5q7XQQ0zI/Hc4Itr3n7D2VIiB+wixXanxzsutZFKVdJ5wnQEkAUGQEgC/z67iePygzv6UYjM4xsrStGQtYbp9Aw6mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nm7JD8Su; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4551F000E9;
	Mon, 25 May 2026 00:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779667582;
	bh=LgC1MDxQTYdqHAPzuT6k6NdmrfH+EdwjIfbtvZG8Y2w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nm7JD8SupFt846zDBPbViKiwC7uo8l0Q2KP31h4258Tui9VvGZue2wx6Ue4UfXzMR
	 BpaFaUn0h8qa/BfrPYmdjdlaqe/VK9oFkR62IEa6/iux7vaLA6LO9U4bGXWvn7VDNg
	 xiXv5DyMUHsSHZA2NgS0nWtlzBXMW8TFLjlDQnJSsOV7J3yJHJDrdFYAtnN3LPoGkQ
	 /CqoWVF50tpBuq8Elw/rk4qZ9tsTRfNV1s/wdH0q9614XegHrF/K7/t+TtbwNGI/aB
	 dN2kJFaNxgsa3KhqO9HiGSSMzF4PFq78A1DzRb932Q91y92qf8akypKiOd4m5QkQuT
	 Qg2RwF22u9E3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] selftests: livepatch: Remove leftover modules when
 a testcase fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josh Poimboeuf" <jpoimboe@kernel.org>, "Joe Lawrence" <joe.lawrence@redhat.com>, "Jiri
 Kosina" <jikos@kernel.org>, "Miroslav Benes" <mbenes@suse.cz>, "Petr Mladek" <pmladek@suse.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: "Marcos Paulo de Souza" <mpdesouza@suse.com>, linux-kselftest@vger.kernel.org, marcos@mpdesouza.com, live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260524-livepatch-unload-on-fail-v1-2-7465de7f741d@suse.com>
References: <20260524-livepatch-unload-on-fail-v1-2-7465de7f741d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 25 May 2026 00:06:21 +0000
Message-Id: <20260525000622.3D4551F000E9@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2882-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,suse.com:email,sashiko.dev:url,smtp.kernel.org:mid,lists.linux.dev:replyto]
X-Rspamd-Queue-Id: 4CD4F5C4FBE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The cleanup loop iterates over the TEST_MODS array in forward or=
der, violating dependency requirements and causing rmmod to fail.
- [Medium] Functions invoked during cleanup call die() on failure, prematur=
ely aborting the EXIT trap and skipping pop_config().
--

commit aafb48b2a54fe2209742378f31fb96583598557a
Author: Marcos Paulo de Souza <mpdesouza@suse.com>

selftests: livepatch: Remove leftover modules when a testcase fails

This commit introduces a cleanup mechanism for livepatch selftests that
tracks loaded modules and attempts to remove them if a test fails or exits
prematurely. It uses a TEST_MODS array to keep track of dependencies and
unloads the remaining modules during an EXIT trap.

> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testi=
ng/selftests/livepatch/functions.sh
> index 3ec0b7962fc5c..25f1370038654 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
[ ... ]
> @@ -125,6 +127,14 @@ function set_ftrace_enabled() {
>  }
> =20
>  function cleanup() {
> +	# Remove leftover modules in reverse order to handle dependencies
> +	for mod_item in "${TEST_MODS[@]}"; do

[Severity: Medium]
Does this loop actually iterate in reverse order?

The comment states the modules will be removed in reverse order to handle
dependencies, but ${TEST_MODS[@]} expands the array in ascending index
order.

Because dependent modules (like livepatches) are loaded after their base
modules, iterating in forward order will attempt to unload the base modules
first. This would likely cause rmmod to fail with a module in use error.

> +		if is_livepatch_mod "$mod_item"; then
> +			disable_lp "$mod_item"
> +		fi
> +		_remove_mod "$mod_item"

[Severity: Medium]
Can this call prematurely abort the cleanup process?

The cleanup() function is executed within an EXIT trap. If _remove_mod()
fails to unload a module, it calls die() which executes an exit command:

tools/testing/selftests/livepatch/functions.sh:_remove_mod() {
    ...
    die "failed to unload module $mod (/sys/module)"
}

Executing exit inside a bash EXIT trap immediately halts the execution of
the trap itself. This would abruptly skip the remaining iterations of the
module cleanup loop and skip the subsequent pop_config() call.

Failing to execute pop_config() leaves the global kernel debug and tracing
configurations modified, which could pollute the state of the test system.

> +	done
> +
>  	pop_config
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260524-livepatch-=
unload-on-fail-v1-0-7465de7f741d@suse.com?part=3D2

