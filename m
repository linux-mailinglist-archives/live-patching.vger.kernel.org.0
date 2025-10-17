Return-Path: <live-patching+bounces-1760-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1CFBEB5BF
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 21:09:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A7AA7432C3
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 19:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0AF3370F1;
	Fri, 17 Oct 2025 19:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkFgPKL0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA44B33291A
	for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 19:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760728076; cv=none; b=eprAXQgJk4gosHYZyYuOHz3ScOiipyDf3eXttognKAlQjIa59+PruMniEhwcPzjm6hWTbD339oUGcRSGOWsqiAOW75D8gWVMu3iMJJEZOk+DKv3zfiEB3MFz5ZaeHhcDJLY9sLs4MRi7OwhiP+vB19rjrcf0FI+MhDSOs06kwXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760728076; c=relaxed/simple;
	bh=eGJK1bnsbR/Hy3T6tf33DXk/b8sOgaKuO4+hpOfVb1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P9maTemK98JFn1pZnJ5EqpjOV/Rmn4KdW+UbsI/TitJ3T8Z6fEaN/PcjDSZOL8a1HhXe7jUZuQvOBFPvnn7BCyidNolvXmm9FBOjh6eSLN8HEGnhwYDZJawu+yUohrc6lx5RQzNhj5k22iT+jqrUvRVlnrtMoTR5fjJqqO+K7oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkFgPKL0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA636C19425
	for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 19:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760728075;
	bh=eGJK1bnsbR/Hy3T6tf33DXk/b8sOgaKuO4+hpOfVb1c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rkFgPKL0AvOkdHKuehivOYdV9t+gR+MjXg1nqT76NlEB2HnqIP8W3fk1/Gn3JLj+a
	 +5d086BtSEWbkd02BdhQUrOZ4Dl5UjHdd7aBxlEvSnF52zJG0g2v8enQVNbQG5aMpj
	 FHP7fCt2VefY14e2Me1/Y9ulfbBgy/9+jCvyh2lOVDtPm0r0AsN3OboKnW+lXDGqyG
	 37+bt3Q8avi/2HauP8Y8PJ1/iKdGY/0R9LGvEmeG4zjROpnQd2zCOMKb/FVyuiFLMK
	 mooYOt5rip5NXVPvReDUOxnYJW74lnG8ImMpF3XlLv11IirdFAtEtZ6DQXBvATnoJl
	 LaVkliw3KlpBQ==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-791fd6bffbaso36304086d6.3
        for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 12:07:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX89BdD8rUzenAwghYCpLC8ZUtlWqmByAmp73IzXOEr0stv1s9XTSa8h2WAKuTDGHlnXeQv9zNgO4Gmi3z/@vger.kernel.org
X-Gm-Message-State: AOJu0YwVnrnMVe+xPeHdixiMtz/BPoi4mmB3tsjf+3QZdADR+8v1UgB4
	B6YWAQoOXdOmcnxiBv2M4gO1B768vsuY5LpptemTSWz0EuHjj41plfCzjRFQ5rQUZEINujuxMCZ
	XJeFciKzI0v3ohBYi/09N454ul/aqLiA=
X-Google-Smtp-Source: AGHT+IFnU4e3IaXoKpnqp+a8weXADxrj1NuhCEOn26Hwf1Pgb7vi8wiieFNnos8MKFi1PXwAxj9a+tdXEHK0h8hCWMI=
X-Received: by 2002:a05:6214:2a83:b0:87d:c7f3:c93a with SMTP id
 6a1803df08f44-87dc7f3cb54mr991696d6.61.1760728074623; Fri, 17 Oct 2025
 12:07:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz> <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz> <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com> <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
In-Reply-To: <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Fri, 17 Oct 2025 12:07:40 -0700
X-Gmail-Original-Message-ID: <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
X-Gm-Features: AS18NWAgrcU_4X1kwNmlh5JLZbaVw7YDSJU2f3Dhqu0SBX5Cp3VLOk0p-MY1lz8
Message-ID: <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Song Liu <song@kernel.org>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: multipart/mixed; boundary="0000000000006f6f6306415f7310"

--0000000000006f6f6306415f7310
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 9:58=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Thu, Oct 16, 2025 at 2:55=E2=80=AFPM Andrey Grodzovsky
> <andrey.grodzovsky@crowdstrike.com> wrote:
> [...]
> > [AG] - Trying first to point him at the original  function - but he
> > fails on the fexit I assume  - which is strange, I assumed fexit
> > (kretfunc) and livepatch can coexist ?
> >
> > ubuntu@ip-10-10-114-204:~$ sudo bpftrace -e
> > 'fentry:vmlinux:begin_new_exec { @start[tid] =3D nsecs; printf("-> EXEC
> > START (fentry): PID %d, Comm %s\n", pid, comm); }
> > fexit:vmlinux:begin_new_exec { $latency =3D nsecs - @start[tid];
> > delete(@start[tid]); printf("<- EXEC END (fexit): PID %d, Comm %s,
> > Retval %d, Latency %d us\n", pid, comm, retval, $latency / 1000); }'
> > Attaching 2 probes...
> > ERROR: Error attaching probe: kretfunc:vmlinux:begin_new_exec
> >
> > [AG] - Trying to skip the fexit and only do fentry - he still rejects
> > ubuntu@ip-10-10-114-204:~$ sudo bpftrace -vvv -e
> > 'fentry:vmlinux:begin_new_exec { @start[tid] =3D nsecs; printf("-> EXEC
> > START (fentry): PID %d, Comm %s\n", pid, comm); }'
> > sudo: unable to resolve host ip-10-10-114-204: Temporary failure in nam=
e
> > resolution
> > INFO: node count: 12
> > Attaching 1 probe...
> >
> > Program ID: 295
> >
> > The verifier log:
> > processed 50 insns (limit 1000000) max_states_per_insn 0 total_states 3
> > peak_states 3 mark_read 1
> >
> > Attaching kfunc:vmlinux:begin_new_exec
> > ERROR: Error attaching probe: kfunc:vmlinux:begin_new_exec
>
> OK, I could reproduce this issue and found the issue. In my test,
> fexit+livepatch works on some older kernel, but fails on some newer
> kernel. I haven't bisected to the commit that broke it.
>
> Something like the following make it work:
>
> diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
> index 2e113f8b13a2..4277b4f33eb8 100644
> --- i/kernel/trace/ftrace.c
> +++ w/kernel/trace/ftrace.c
> @@ -5985,6 +5985,8 @@ int register_ftrace_direct(struct ftrace_ops
> *ops, unsigned long addr)
>         ops->direct_call =3D addr;
>
>         err =3D register_ftrace_function_nolock(ops);
> +       if (err)
> +               remove_direct_functions_hash(direct_functions, addr);
>
>   out_unlock:
>         mutex_unlock(&direct_mutex);
>
> Andrey, could you also test this change?

Attached is a better version of the fix.

Thanks,
Song

--0000000000006f6f6306415f7310
Content-Type: application/octet-stream; 
	name="0001-ftrace-Fix-BPF-fexit-with-livepatch.patch"
Content-Disposition: attachment; 
	filename="0001-ftrace-Fix-BPF-fexit-with-livepatch.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mgv805oh0>
X-Attachment-Id: f_mgv805oh0

RnJvbSBkNGFhOWMwMDU4Yzc5NGQ2MjU5MjQ4MTg3YmQ1ODk2Y2I0MGVlYTI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPgpEYXRlOiBGcmks
IDE3IE9jdCAyMDI1IDExOjQ5OjQ1IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gZnRyYWNlOiBGaXgg
QlBGIGZleGl0IHdpdGggbGl2ZXBhdGNoCgpXaGVuIGxpdmVwYXRjaCBpcyBhdHRhY2hlZCB0byB0
aGUgc2FtZSBmdW5jdGlvbiBhcyBicGYgdHJhbXBvbGluZSB3aXRoCmEgZmV4aXQgcHJvZ3JhbSwg
YnBmIHRyYW1wb2xpbmUgY29kZSBjYWxscyByZWdpc3Rlcl9mdHJhY2VfZGlyZWN0KCkKdHdpY2Uu
IFRoZSBmaXJzdCB0aW1lIHdpbGwgZmFpbCB3aXRoIC1FQUdBSU4sIGFuZCB0aGUgc2Vjb25kIHRp
bWUgaXQKd2lsbCBzdWNjZWVkLiBUaGlzIHJlcXVpcmVzIHJlZ2lzdGVyX2Z0cmFjZV9kaXJlY3Qo
KSB0byB1bnJlZ2lzdGVyCnRoZSBhZGRyZXNzIG9uIHRoZSBmaXJzdCBhdHRlbXB0LiBPdGhlcndp
c2UsIHRoZSBicGYgdHJhbXBvbGluZSBjYW5ub3QKYXR0YWNoLiBIZXJlIGlzIGFuIGVhc3kgd2F5
IHRvIHJlcHJvZHVjZSB0aGlzIGlzc3VlOgoKICBpbnNtb2Qgc2FtcGxlcy9saXZlcGF0Y2gvbGl2
ZXBhdGNoLXNhbXBsZS5rbwogIGJwZnRyYWNlIC1lICdmZXhpdDpjbWRsaW5lX3Byb2Nfc2hvdyB7
fScKICBFUlJPUjogVW5hYmxlIHRvIGF0dGFjaCBwcm9iZTogZmV4aXQ6dm1saW51eDpjbWRsaW5l
X3Byb2Nfc2hvdy4uLgoKRml4IHRoaXMgYnkgdXBkYXRpbmcgZGlyZWN0X2Z1bmN0aW9ucyBoYXNo
IGFmdGVyCnJlZ2lzdGVyX2Z0cmFjZV9mdW5jdGlvbl9ub2xvY2sgc3VjY2VlZHMuCgpGaXhlczog
ZDA1Y2I0NzA2NjNhICgiZnRyYWNlOiBGaXggbW9kaWZpY2F0aW9uIG9mIGRpcmVjdF9mdW5jdGlv
biBoYXNoIHdoaWxlIGluIHVzZSIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgdjYuNisK
UmVwb3J0ZWQtYnk6IEFuZHJleSBHcm9kem92c2t5IDxhbmRyZXkuZ3JvZHpvdnNreUBjcm93ZHN0
cmlrZS5jb20+CkNsb3NlczogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGl2ZS1wYXRjaGluZy9j
NTA1ODMxNWEzOWQ0NjE1YjMzM2U0ODU4OTMzNDViZUBjcm93ZHN0cmlrZS5jb20vCkNjOiBTdGV2
ZW4gUm9zdGVkdCAoR29vZ2xlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4KQ2M6IE1hc2FtaSBIaXJh
bWF0c3UgKEdvb2dsZSkgPG1oaXJhbWF0QGtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6IFNvbmcg
TGl1IDxzb25nQGtlcm5lbC5vcmc+Ci0tLQoga2VybmVsL3RyYWNlL2Z0cmFjZS5jIHwgMTAgKysr
KysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMgYi9rZXJuZWwvdHJhY2UvZnRyYWNl
LmMKaW5kZXggYTY5MDY3MzY3YzI5Li44MmEwNmI3ZDAyNjggMTAwNjQ0Ci0tLSBhL2tlcm5lbC90
cmFjZS9mdHJhY2UuYworKysgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMKQEAgLTYwMzgsMTYgKzYw
MzgsMTggQEAgaW50IHJlZ2lzdGVyX2Z0cmFjZV9kaXJlY3Qoc3RydWN0IGZ0cmFjZV9vcHMgKm9w
cywgdW5zaWduZWQgbG9uZyBhZGRyKQogCQl9CiAJfQogCi0JZnJlZV9oYXNoID0gZGlyZWN0X2Z1
bmN0aW9uczsKLQlyY3VfYXNzaWduX3BvaW50ZXIoZGlyZWN0X2Z1bmN0aW9ucywgbmV3X2hhc2gp
OwotCW5ld19oYXNoID0gTlVMTDsKLQogCW9wcy0+ZnVuYyA9IGNhbGxfZGlyZWN0X2Z1bmNzOwog
CW9wcy0+ZmxhZ3MgPSBNVUxUSV9GTEFHUzsKIAlvcHMtPnRyYW1wb2xpbmUgPSBGVFJBQ0VfUkVH
U19BRERSOwogCW9wcy0+ZGlyZWN0X2NhbGwgPSBhZGRyOwogCiAJZXJyID0gcmVnaXN0ZXJfZnRy
YWNlX2Z1bmN0aW9uX25vbG9jayhvcHMpOworCWlmIChlcnIpCisJCWdvdG8gb3V0X3VubG9jazsK
KworCWZyZWVfaGFzaCA9IGRpcmVjdF9mdW5jdGlvbnM7CisJcmN1X2Fzc2lnbl9wb2ludGVyKGRp
cmVjdF9mdW5jdGlvbnMsIG5ld19oYXNoKTsKKwluZXdfaGFzaCA9IE5VTEw7CiAKICBvdXRfdW5s
b2NrOgogCW11dGV4X3VubG9jaygmZGlyZWN0X211dGV4KTsKLS0gCjIuNDcuMwoK
--0000000000006f6f6306415f7310--

