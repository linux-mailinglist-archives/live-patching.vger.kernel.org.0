Return-Path: <live-patching+bounces-1829-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D15CDC27EF1
	for <lists+live-patching@lfdr.de>; Sat, 01 Nov 2025 14:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 902B7401477
	for <lists+live-patching@lfdr.de>; Sat,  1 Nov 2025 13:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3642A1FF1C8;
	Sat,  1 Nov 2025 13:11:16 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EAB1E520E;
	Sat,  1 Nov 2025 13:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762002676; cv=none; b=DpZaCZxowlrbF98xhTWs2PWeQoidgxTAONEN1yJhotZTc7uDlVyA4/1S6R127WD+CSqX4jvxG1tqtkjyGLm8v+O0jSRbc9VuZtHi6+2hlhNpUZ4x59XZnhS+oWFWVz0ns/ih4mlafbrIiORwVrwBjGo5PonVYsYCot1ckAJEF3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762002676; c=relaxed/simple;
	bh=AzJn2EhpdKUavXcHL1YNtazEeTIv9k3oI1R5Sb6/0pw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8Sr760Yldl/kzIYQc1VXwNV3s8LuU/xXztOgp7egZA8njYOef3V5ZRqT54LPi1JMJdk2jClq7JpupylyNfSeonlnDYntQtrdxcjDKpOakzKuB5kw2EGrSMn/BCl2iE2oRP5ODmNy7nMqvZQRcafCqyhBE2rcXkASGvb8uaEhF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8A4912BBA1;
	Sat,  1 Nov 2025 13:11:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 25D052002C;
	Sat,  1 Nov 2025 13:11:08 +0000 (UTC)
Date: Sat, 1 Nov 2025 09:11:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
 live-patching@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Kernel Team <kernel-team@meta.com>, Jiri Olsa
 <olsajiri@gmail.com>
Subject: Re: [PATCH v4 bpf 0/3] Fix ftrace for livepatch + BPF fexit
 programs
Message-ID: <20251101091116.763638e5@batman.local.home>
In-Reply-To: <CAADnVQ+azh4iUmq4_RHYatphAaZUGsW0Zo8=vGOT1_fv-UYOaA@mail.gmail.com>
References: <20251027175023.1521602-1-song@kernel.org>
	<CAADnVQ+azh4iUmq4_RHYatphAaZUGsW0Zo8=vGOT1_fv-UYOaA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 25D052002C
X-Stat-Signature: yryycompfdensi6cmw3ygrpxsqrgixsi
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/WMseIXgL+xST54cTWn2OWaUeAAwNYOdg=
X-HE-Tag: 1762002668-277336
X-HE-Meta: U2FsdGVkX1+VbKDVvTMG90gnNSTYjxs1WemFaEWHqAb83xKjom5E2rTtTwXrnX+sJTRFB67F6yYYmLreq0fkoE5G6ykVnT/+zmo35uJPqTz/cd37VPZ2kf67u2ET6QiV3FepIKbEiFmi+ay0u/nGAij38nyGBHJ9uEOAgh5R8oFID0JTPcJky2AWXEO+FGyZa5rxXDd5MAoJAFjI5v5bIRuDT8hd2mgCpesnFsaK+OW7VKjOGQnKyMspbCQn6rN4Zx0KFikopcYWBbpGQ+LZ4gV6WfvGngoLLG5EuDUHb9sqvFpaJkmBvRa5UYvs1e6Dgi3QIBuq8fh0LznHLdTDy7BXvjr9I+Ch0w51CPpPqJrU2Ywl5Hb2nQ==

On Fri, 31 Oct 2025 17:19:54 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> can you apply the fixes or should I take them ?
> If so, pls ack.

Let me run them through my full test suite. It takes up to 13 hours to
run. Then I'll give a ack for you to take them.

-- Steve

