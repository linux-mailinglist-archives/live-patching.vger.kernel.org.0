Return-Path: <live-patching+bounces-2288-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IABSM5Hnz2kS1gYAu9opvQ
	(envelope-from <live-patching+bounces-2288-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 18:15:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 488543962A3
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 18:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48E7331042E8
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 16:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F373CCA1A;
	Fri,  3 Apr 2026 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2qAfo94"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D633C9EC0
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775232422; cv=none; b=nEnfPvE7jhw4B2rAvN3hpE4b7Tt1+ZvlPmj38nUhR4JZu6GkOZADRpBSRc1uYIdEhzb3tefS9oJzxeNhPqTVCuNgEaloSMRyu0sugD7K+CfmpdLtEVdoiZbYvZBWl/pzCZvD1KySTvILiEcJEt5zgocaYHLBmSVLJo3BO8sHADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775232422; c=relaxed/simple;
	bh=VgMTj/MSX86VvvlFowbzT2maCh5ozW0tOeKlicuhWJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RaBd4XjyXfWZv5vjtuPzGaWWUpd93kdXy86XwkwhwirNWMZIOcNUMhSxLQFVzFXJ8CvBLHMztunJV9lTfObJd/L1o50y774JbSMUo9E+gnOe/VKD1s9jcKcqhaBDe6n/jTQSqN4FWbhfvYH4NmD+qhxGQNN0cdPdfltjJTynAUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2qAfo94; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB056C2BCC9
	for <live-patching@vger.kernel.org>; Fri,  3 Apr 2026 16:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775232421;
	bh=VgMTj/MSX86VvvlFowbzT2maCh5ozW0tOeKlicuhWJA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t2qAfo94ucUEw1uQEKuh9QVmJYQWO9+Oz9GjZuxdmQ3pruCeGRSgNuy0mes5GIYic
	 tFf/iKHxu97pyzjRMJXVFrgX3l/ungrMBzclA32GRfDl719g3D9VnXdlniz0Fv5kj8
	 zfafTtG1rfI9dxRHvaHGlIBpK1GRLnfONT8x/S0HPPOefYRMKDWSydn3/BYcDLnYGI
	 IXidIhIEQXjBXdIoZFiU+il5Yuatq6aXnD1lyfAKVLfUhfC9OWn4iDw0sjSmpHOU/f
	 C5YJjfPJkitOT2hlIEiObF4TWsXNpXyXOCCz/84xdNqVdXdosJrk9sV6m9lRXy4UV6
	 y5htW4nD4zAiQ==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-89cc71f4311so26989136d6.3
        for <live-patching@vger.kernel.org>; Fri, 03 Apr 2026 09:07:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUPpeG7OPTkw3kZKH7QCky0/CT605JHM4RBGu3kfz1H2+ox3gIH9pOMQJQEMh7hVPGZtDmvQdHS1oz//vK5@vger.kernel.org
X-Gm-Message-State: AOJu0YyqL9O8N7K3gm7eVPxRyhDWcbm1N785deycaTh7SF9Bzbm3IgUd
	BKbZs6DMr0W2HTUQkssm8ZrVNpCnMDkHhNa4LuIg2dzXbAsfHvyELguJbcUe971Q1dJ5NrVmz93
	2cNE91koKzachW5y0KEJLZHW4t0diDfU=
X-Received: by 2002:a05:6214:2422:b0:89c:d931:62ee with SMTP id
 6a1803df08f44-8a7041fd1f4mr55594166d6.34.1775232420638; Fri, 03 Apr 2026
 09:07:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com>
In-Reply-To: <20260402092607.96430-1-laoar.shao@gmail.com>
From: Song Liu <song@kernel.org>
Date: Fri, 3 Apr 2026 09:06:49 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
X-Gm-Features: AQROBzAm0t2b67APn7ntpBbViV_qfNNj9_UUU_aG9AkiVCLDMIVGO7FMUNPLhp4
Message-ID: <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2288-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 488543962A3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Yafang,

On Thu, Apr 2, 2026 at 2:26=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> Livepatching allows for rapid experimentation with new kernel features
> without interrupting production workloads. However, static livepatches la=
ck
> the flexibility required to tune features based on task-specific attribut=
es,
> such as cgroup membership, which is critical in multi-tenant k8s
> environments. Furthermore, hardcoding logic into a livepatch prevents
> dynamic adjustments based on the runtime environment.
>
> To address this, we propose a hybrid approach using BPF. Our production u=
se
> case involves:
>
> 1. Deploying a Livepatch function to serve as a stable BPF hook.
>
> 2. Utilizing bpf_override_return() to dynamically modify the return value
>    of that hook based on the current task's context.

Could you please provide a specific use case that can benefit from this?
AFAICT, livepatch is more flexible but risky (may cause crash); while
BPF is safe, but less flexible. The combination you are proposing seems
to get the worse of the two sides. Maybe it can indeed get the benefit of
both sides in some cases, but I cannot think of such examples.

Thanks,
Song

