Return-Path: <live-patching+bounces-2281-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCJtOzBvzmnxngYAu9opvQ
	(envelope-from <live-patching+bounces-2281-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 15:29:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A8A1389BDA
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 15:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EAD07304F0BB
	for <lists+live-patching@lfdr.de>; Thu,  2 Apr 2026 13:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9043009CB;
	Thu,  2 Apr 2026 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bm440UxV"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AC33009E1
	for <live-patching@vger.kernel.org>; Thu,  2 Apr 2026 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775136095; cv=pass; b=oNgGA8oEel4nbRluDPRM60DE9JBTaAK9SE/lfVKwTcAM8jCYtYazAvDIZstFnK7OSjNld9/is2ChbAuvNnHbKzfHAYfy2ffuty/1KvwdWc/3WLlXphTlJcP+bMgTQmkrpmJEzYYlq+kc1AgucztZAZpWwQ0ZLsVfxzMk7ndLC2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775136095; c=relaxed/simple;
	bh=92ifLkSB1QdWZYuCe2bJNqdGfTWsYwdd5FnM5cH+Uek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0pqorzJiW3Vm+uAtf1eeQc2GA0ZPP0bWIRPyhafpgW2Zh/CadW5TwlbpLS0wkmJFbfFMa9b231YMKE/T4rJ/7wRuBe7RlfmrTbBLQt0fBXNiHroX714xfyzwcsdclmdZLFSHlEnCc1X1v187ZA0NGCSPT4qquHZUFWeetG0XVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bm440UxV; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-650182d19e0so1007794d50.1
        for <live-patching@vger.kernel.org>; Thu, 02 Apr 2026 06:21:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775136092; cv=none;
        d=google.com; s=arc-20240605;
        b=EgF7S/uIrKrpYIn5Clv2VlSZPHe4rAhWZ7mYsbVsJxlI8TEXcMPkzJiXzZV0C/wLY9
         aFm0ftgv1xHCkeChnJ/bSEkGFxag3rPNvE1Cld/7D1wPC5YszxoLj62M7VL8gx3fl8uF
         msdIiAAc2ZQy7njwq2pTZaKfJNbawlp4/e/79oK85bMGV7FN9yvFoIsAfEsvMBddMCqJ
         S3nC3yjoUI58HlsHlGkKsJ9CcEkDfGlxwSR/Wv4t//Cjs+6XhUZT6ISybxLx/RDTTyh6
         tMxzxokt1oyPLt0XMS84GGgyJL9SPIWSyNmOE7L/KPcHEslaMeMpP5czXRR1vMfgsUxF
         mDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P/+RvF4sr+15hFwCy/1QY5L6R+YF2MZZgsand9uX2p8=;
        fh=jYJu8ioX08RSz/5FEIL9oJBa/ENZKiq8TjDqx+LV88E=;
        b=HlailPeb7wTpyPMCIe02T36YG/HP25pPkumqwYuCJasEm9Q3Mz10LayGS0sFoZ8YLT
         oY6B3BnGDd09ALKr/h0+wequifiw5zPXNnZ0BOBqgP14Y53BlsKuShMq8TwAcSt5cBTI
         O5sCl2lmbkG5b3g5BI4WgKdu28M9t2STD2DzM0s4mSeVL5Wja4LQNZSnQeoheZXQR3Zv
         GRBFYqIOvzls5bQUcpjIRxTTLXNiSR+shmUbfBl50vY0zawwr0mlK9aLct1NZi3wmAeH
         wlSwSQ4CjAtuWdqT/uRYtLHQpGu45EbhUOPc5aBTF/SW2WzmR3NnxjP6rkwJN4u4zoqX
         LGgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775136092; x=1775740892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/+RvF4sr+15hFwCy/1QY5L6R+YF2MZZgsand9uX2p8=;
        b=bm440UxVqOnXh6b79oWalrfPhYQW4Z4WKNgYdrdUK1TF6rlQ+wO//yT5nDSYwBpe3M
         3MYDe4jfdPdbEl7PS44Kgmpq8yYKdubvQ47hwwMqs53YJ80dz4kjNeLojz5hgjx3XwTU
         gJaFWlU6BeYPAubFhHOeQxQ2cuypCd4CETGTOo0weQaD/vJX41vy10Sc9AtyZyljjU+r
         rLorbuhQ4KlOzPJRLkwqiSgpLGB+PKnB6jKEE8KraTzJfylZ1LVZ7FOcedxsx40wpDEl
         L4qV9CCZs7MVqHczcsg5xWjAXt48v3RGnbBt9YoZ0YiMnmCIkOjkqIKWS3OZwkje6GRN
         JbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775136092; x=1775740892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P/+RvF4sr+15hFwCy/1QY5L6R+YF2MZZgsand9uX2p8=;
        b=TjObQIk/ISv73QdYnckHRUw1nhzp2rgtomdAYbWpAzKCG5YnqeBMOMB62UIN4H2eFD
         Ym234H4z5+5gKxhefhIZt4s+YCmqAw6ZpyONz4hI1eBZ0CfVI0xdKbr8ipfgvSPVpSl0
         OWWH0E6fSX6yVIvi5Ns6up+tO9TH1kFjkARwkcS6A75Ux2h6tOeKJZcPeVxh17+vnRw8
         ORz9yG6+5kN3ziQE+GbcaAikxjWU31HGAq22XB1KngQeJE+k9deOebZm76fo66ccgiNa
         yiQdwBb3C7rO0YGYJBQHPG1POp1aA6BsnKd7mp5RDixWlyLdxjkHkTbg4sVJomNI5P14
         ORvA==
X-Forwarded-Encrypted: i=1; AJvYcCXCCYFv/QszIkxLG+ECKC0pk2jtDP3lL5VqW+sq2ML5N+DoZvy6EcH++FPb+oLhUoWBEeF6zyj9EuKJ7pjd@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvux8xPIhK4lBkpqNGdGuG/IXrE6WTc/rWo2QqrGYXriWRDxQL
	KCXH4EjnySoXkuwCB9mQABrUBerIFtK0SB4w0wqadccHJ3E9FeYHnHna/MjCtTlzmDI+RL4modF
	rPSb4HbivkfrNQTNOCbRLRXZAilfevp8=
X-Gm-Gg: AeBDietIijP4zp5gfSThBzVG3VCK/7db3gJ2Sctd7b7gE2B0C+FNshnx5ee7UlpwstC
	lFL12yKHHCVoNyBvNfUxXaKmg1t5dTppfpAm9wqx2RYVioXx9SUF4qszwgqZYR5O6tD65OX6IYN
	J78McEJAjEP2txPmm+TMkngi2FPL6jon64VwFKwhQGVvLUeW3rN3y+VwQ1cEKy5SF++aEONnb/g
	sqDs0+7aOJUu4fVM6B6Y4dnw97bCfVF4jghZuYOWUaLERbWb/AB82f7slp+oIvF7hj/sUCc7gka
	IFMgCrrM
X-Received: by 2002:a05:690e:144b:b0:649:bbf4:121b with SMTP id
 956f58d0204a3-6502fd9534cmr7636575d50.2.1775136092404; Thu, 02 Apr 2026
 06:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-3-laoar.shao@gmail.com>
 <2261072.irdbgypaU6@7950hx>
In-Reply-To: <2261072.irdbgypaU6@7950hx>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 2 Apr 2026 21:20:55 +0800
X-Gm-Features: AQROBzCq379oCyNjtOYZmuBoMyOqOT1_VV-wnZMWv4kRMd3OjGsW1s1XAyz2G-0
Message-ID: <CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqgeo4C0iA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
To: Menglong Dong <menglong.dong@linux.dev>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	song@kernel.org, jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2281-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 8A8A1389BDA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 2, 2026 at 8:48=E2=80=AFPM Menglong Dong <menglong.dong@linux.d=
ev> wrote:
>
> On 2026/4/2 17:26, Yafang Shao wrote:
> > Introduce the ability for kprobes to override the return values of
> > functions that have been livepatched. This functionality is guarded by =
the
> > CONFIG_KPROBE_OVERRIDE_KLP_FUNC configuration option.
>
> Hi, Yafang. This is a interesting idea.
>
> For now, the bpf_override_return() can only be used on the kernel
> functions that allow error injection to prevent the BPF program from
> crash the kernel. If we use it on the kernel functions that patched
> by the KLP, we can crash the kernel easily by return a invalid value
> with bpf_override_return(), right? (Of course, we can crash the kernel
> easily with KLP too ;)

Right.
Livepatch already grants the power to modify the kernel at will;
allowing BPF to override a patched function simply adds a layer of
runtime programmability to an existing modification.

>
> I haven't figure out the use case yet. Can KLP be used together with
> the BPF program that use bpf_override_return()?

The two mechanisms do not target the same entry point: whileKLP
modifies the original kernel function, bpf_override_return() is
applied to the newly patched function provided by the KLP module.

> The KLP will modify
> the RIP on the stack, and the bpf_override_return() will modify it too.
> AFAIK, there can't be two ftrace_ops that both have the
> FTRACE_OPS_FL_IPMODIFY flag. Did I miss something?

Correct, but as noted, they target different functions

>
> It will be helpful for me to understand the use case if a selftests is
> offered :)

Here is a recent use case from our production environment.

- The livepatch

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index e378bbe5705f..047e937bfa6d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5175,12 +5175,22 @@ int bond_update_slave_arr(struct bonding
*bond, struct slave *skipslave)
        return ret;
 }

+/* noclone to avoid bond_get_slave_hook.constprop.0 */
+__attribute__((__noclone__, __noinline__))
+int bond_get_slave_hook(struct sk_buff *skb, u32 hash, unsigned int count)
+{
+       return -1;
+}

 static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
                                                 struct sk_buff *skb,
                                                 struct bond_up_slave *slav=
es)
 {
        struct slave *slave;
        unsigned int count;
+       int slave_idx;
        u32 hash;

        hash =3D bond_xmit_hash(bond, skb);
@@ -5188,6 +5198,13 @@ static struct slave
*bond_xmit_3ad_xor_slave_get(struct bonding *bond,
        if (unlikely(!count))
                return NULL;

+       /* Try BPF hook first - returns slave index directly */
+       slave_idx =3D bond_get_slave_hook(skb, hash, count);
+       /* If BPF hook returned valid slave index, use it */
+       if (slave_idx >=3D 0 && slave_idx < count) {
+               slave =3D slaves->arr[slave_idx];
+               return slave;
+       }
        slave =3D slaves->arr[hash % count];
        return slave;
 }

- The BPF program

SEC("kprobe/bond_get_slave_hook")
int BPF_KPROBE(slave_selector, struct sk_buff *skb, u32 hash, u32 count)
{
        unsigned short net_hdr_off;
        unsigned char *head;
        struct iphdr iph;
        int *slave_idx;
        __u32 daddr;

        __u16 proto =3D BPF_CORE_READ(skb, protocol);
        if (proto !=3D bpf_htons(0x0800))
                return 0;

        head =3D BPF_CORE_READ(skb, head);
        net_hdr_off =3D BPF_CORE_READ(skb, network_header);

        if (bpf_probe_read_kernel(&iph, sizeof(iph), head + net_hdr_off) !=
=3D 0)
                return 0;

        daddr =3D iph.daddr;
        slave_idx =3D bpf_map_lookup_elem(&ip_slave_map, &daddr);
        if (slave_idx) {
                int idx =3D *slave_idx;

                if (idx >=3D 0 && idx < (int)count)
                        bpf_override_return(ctx, idx);
        }
        return 0;
}

>
> BTW, if we allow the usage of bpf_override_return() on the KLP patched
> function, we should allow the usage of BPF_MODIFY_RETURN on this
> case too, right?

It's a possibility, but I haven't tested that specifically yet.

--=20
Regards
Yafang

