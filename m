Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0419416E934
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2020 16:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbgBYPBL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Feb 2020 10:01:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730958AbgBYPBK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Feb 2020 10:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582642869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ULjGkWTIVT0iQqr4VAoSIQ4cPhGUNMPfY7Wm+7UQ8w=;
        b=YGb0+qLZ0nKwxXeT+qmbbsB3csXANApoSKS/Wo8pia3qJYO68CZTUlklsW1+Gok3C0d44A
        OBEq30OC4tg0A/wT3q8O/niDmaQms0v2/Bp6/ACDOC2lKZfQW13jvQkifC3Hjl0qoBFp1a
        jnRgQUTI+1ApVoZkZp54nLUMbQEIo3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-53fqC5C8MaGqofn20Xz7ew-1; Tue, 25 Feb 2020 10:00:51 -0500
X-MC-Unique: 53fqC5C8MaGqofn20Xz7ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C68B1922965;
        Tue, 25 Feb 2020 15:00:48 +0000 (UTC)
Received: from [10.18.17.119] (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A505390F5F;
        Tue, 25 Feb 2020 15:00:46 +0000 (UTC)
Subject: Re: [PATCH 0/3] Unexport kallsyms_lookup_name() and
 kallsyms_on_each_symbol()
To:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-team@android.com, akpm@linux-foundation.org,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Quentin Perret <qperret@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        live-patching@vger.kernel.org
References: <20200221114404.14641-1-will@kernel.org>
 <alpine.LSU.2.21.2002251104130.11531@pobox.suse.cz>
 <20200225121125.psvuz6e7coa77vxe@pathway.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <943e7093-2862-53c6-b7f4-96c7d65789b9@redhat.com>
Date:   Tue, 25 Feb 2020 10:00:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225121125.psvuz6e7coa77vxe@pathway.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2/25/20 7:11 AM, Petr Mladek wrote:
> On Tue 2020-02-25 11:05:39, Miroslav Benes wrote:
>> CC live-patching ML, because this could affect many of its users...
>>
>> On Fri, 21 Feb 2020, Will Deacon wrote:
>>
>>> Hi folks,
>>>
>>> Despite having just a single modular in-tree user that I could spot,
>>> kallsyms_lookup_name() is exported to modules and provides a mechanis=
m
>>> for out-of-tree modules to access and invoke arbitrary, non-exported
>>> kernel symbols when kallsyms is enabled.
>=20
> Just to explain how this affects livepatching users.
>=20
> Livepatch is a module that inludes fixed copies of functions that
> are buggy in the running kernel. These functions often
> call functions or access variables that were defined static in
> the original source code. There are two ways how this is currently
> solved.
>=20
> Some livepatch authors use kallsyms_lookup_name() to locate the
> non-exported symbols in the running kernel and then use these
> address in the fixed code.
>=20

FWIW, kallsyms was historically used by the out-of-tree kpatch support=20
module to resolve external symbols as well as call set_memory_r{w,o}()=20
API.  All of that support code has been merged upstream, so modern=20
kpatch modules* no longer leverage kallsyms by default.

* That said, there are still some users who still use the deprecated=20
support module with newer kernels, but that is not officially supported=20
by the project.

> Another possibility is to used special relocation sections,
> see Documentation/livepatch/module-elf-format.rst
>=20
> The problem with the special relocations sections is that the support
> to generate them is not ready yet. The main piece would klp-convert
> tool. Its development is pretty slow. The last version can be
> found at
> https://lkml.kernel.org/r/20190509143859.9050-1-joe.lawrence@redhat.com
>=20
> I am not sure if this use case is enough to keep the symbols exported.
> Anyway, there are currently some out-of-tree users.
>=20

Another (temporary?) klp-relocation issue is that binutils has limited=20
support for them as currently implemented:

   https://sourceware.org/ml/binutils/2020-02/msg00317.html

For example, try running strip or objcopy on a .ko that includes them=20
and you may find surprising results :(


As far as the klp-convert patchset goes, I forget whether or not we tied=20
its use case to source-based livepatch creation.  If kallsyms goes=20
unexported, perhaps it finds more immediate users.

However since klp-convert provides nearly the same functionality as=20
kallsyms, i.e. both can be used to circumvent symbol export licensing --=20
one could make similar arguments against its inclusion.


If there is renewed (or greater, to be more accurate) interest in the=20
klp-convert patchset, we can dust it off and see what's left.  AFAIK it=20
was blocked on arch-specific klp-relocations and whether per-object=E2=80=
=8B=20
livepatch modules would remove that requirement.

-- Joe

