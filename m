Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3B4563924
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 20:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiGASXM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 14:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGASXL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 14:23:11 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6EAB20;
        Fri,  1 Jul 2022 11:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1656699784;
        bh=uzoRRqUxyn9+BfbqzqCcGkp9jRq8irddVfgV/XHdums=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Q2ovclgeqBPvymxWK0XJbDvLinOB+pcRMyqUD8KeDchdCGrBAEs7G+n3HUErI0LuU
         pyTcetKomxKZbsNWOk/rpKCp9m2Wy/yeET4k6dliOD2fe4k29mzd0zQV+C+h0YmUFh
         HbBXJP9s9pB1MnYe4UIIt2ZWn2ExGNg6hzNgUELI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.182.192]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MysRk-1nkyrK01Jq-00vxjV; Fri, 01
 Jul 2022 20:23:04 +0200
Message-ID: <26020ab7-3700-89cd-b58a-0d529282dce3@gmx.de>
Date:   Fri, 1 Jul 2022 20:22:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] modules: Ensure natural alignment for
 .altinstructions and __bug_table sections
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        live-patching@vger.kernel.org
References: <20220627190551.517561-1-deller@gmx.de>
 <Yr82t0PQoYIcx++J@bombadil.infradead.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <Yr82t0PQoYIcx++J@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uSbBXmft60MvK/fkCFFGuIhIf5mj0EPZ1ZtWvK9onT+dBfiBedV
 adbYxy19uP46rbYPVd06BoFYXHVZzLSI6Y7pjBr/wN0s4DM7o0Q8TYFMAWwMKywwiNoT2pz
 BAZOcrbnseZ74hlY4mjKPNTuxgN2FkBnjW8x/XolHKiN17MXFzHFXSXEm8L+3M+ogxRxN23
 bGfrD06b14RRCUZIDHSGA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hQqWDUk6yLQ=:priPGNmmZ/IknPUc/PVNth
 Nfw6CJrvMoNJJLjZuCGgwvdpu9O3uaIgsnIKOjb9nd/byJ1LO26SFqG5Jf2USHGuv+4rkzckw
 qHh26/LtAxs52eO4SP76p0u+qZhif24X5PuVxmaJVfFqmwFBJinjIV1muM7EII21vptcAKR/X
 BaUBNWiJ97mVwLS25v+hkZi+Jvm2v3PBwSE9EMJYFLqVU9dNTv7TN56Ss2Kg+0MHr8ekgNVNO
 oW5jMb4BMDqk11qBDHwgeNJgFXE2XyZ9vym8Em3JNnM0YGc+ZTTBuzi8r2HNGe1BUcm0kac91
 sXlDaHqa3KsR7N+JkF7iZ/YKc6D2PHevzK2VSay9atlEZ97YJV6ZjatCsgUVdbD9odNG57y+w
 yq1GYiNvlsw7cubznFo3LH+88mVzVOIOQKG6laOPmxWKsn2u9dML/V75msZELCjiviB0oX5E5
 fSgnWkRTUO5fjvWTu0MUpwBduUEO/miOUczZymXWYplsWDD9UJ+wHQ8qhnU0vNpTVlZfRiWCo
 CiXpKBqs3zY1D9rzgAAkDBpcayjW/GfL5XJv64oC+XZaB+3ICjMzxBFaaNWDB1Oj19BrcofSl
 DW6j/5NSf0rjey6gDRXhNS6Lu+DjrOPXwE2Y8bQPlGOfOcRh96oStuUB9alaBf1gJH85IVbkd
 D7vCOYD/yzhDNje96w0UbYzU/i+fn6FgRFq9jHHmhLZKV6RswTqGer3QgbvaHrJBSUZQYwZIZ
 s67WBL55GGCGDtiKTgPVTlicVM2JS1qhJ8efkVeCGIxBW02P8AqkhT/4PkLovTSS/+/FhK7Lc
 ClCzzESOHySMF7D3sNqFJWLTdRWoO2+Y2RsqCjpX+3bUYJFZOBXemgwb3vtR67bkSALpi6I3c
 zN3vCC/9ZYLwMJE4xDXvTctpY0UBcIlNWH17KbPm/1XV4AhQM16xkkKUWjh0oTc6qB9HFDyAu
 lgfQ+puJfLm/hDfRnQOpyV/+z4r8cMi/FxSpvnKwK9Y6h0kW3mebDvpn5mmDlmXmqCcaBfLW0
 BEOcGc/2DBlVSRWqoSp3p6yMquzIj3MMXuSfLdRcKh7/M4uLW/2OGWSr2g4SiyLCO/e8SaAzW
 6YLENPvEgGPu6828bRcnRVxR8qYW0VNGc4GvAnH39eNnS8XLT4omqPQvg==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/1/22 20:02, Luis Chamberlain wrote:
> On Mon, Jun 27, 2022 at 09:05:50PM +0200, Helge Deller wrote:
>> In the kernel image vmlinux.lds.S linker scripts the .altinstructions
>> and __bug_table sections are 32- or 64-bit aligned because they hold 32=
-
>> and/or 64-bit values.
>>
>> But for modules the module.lds.S linker script doesn't define a default
>> alignment yet, so the linker chooses the default byte-alignment, which
>> then leads to unnecessary unaligned memory accesses at runtime.
>>
>> This patch adds the missing alignments.
>>
>> Signed-off-by: Helge Deller <deller@gmx.de>
>
> Good catch but does this fix a real world issue? When are
> altinstructions used for modules? When are alternatives used
> for modules?
>
> How did you notice this issue?

You are right - usually this is unnoticed, because either the
hardware (on x86 cpus) or by exception handlers (e.g. on hppa
or sparc) fix up such unaligned accesses at runtime.

I noticed that, because on hppa the 32-bit unalignment handler
was broken due a bad commit, and as such wrong values were
returned on unaligned accesses, which then led to other bugs.
For hppa I fixed it with this commit:
https://patchwork.kernel.org/project/linux-parisc/patch/20220626233911.102=
3515-1-deller@gmx.de/

This happened when loading the mptbase kernel module:
https://lore.kernel.org/all/07d91863-dacc-a503-aa2b-05c3b92a1e39@bell.net/=
T/#mab602dfa32be5e229d5e192ab012af196d04d75d
The summary why it went wrong is at the end of that thread.

On hppa we replace "sync" and some other instructions in kernel
and modules - depending on the CPU type (detected at runtime), or
on the environment (e.g. when running in qemu).

IMHO this really should be fixed, esp. since the fix is trivial.

> This information should go into the commit log.

Sure, I'll resend with updated info.

Thanks!
Helge


>>  scripts/module.lds.S | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/scripts/module.lds.S b/scripts/module.lds.S
>> index 1d0e1e4dc3d2..3a3aa2354ed8 100644
>> --- a/scripts/module.lds.S
>> +++ b/scripts/module.lds.S
>> @@ -27,6 +27,8 @@ SECTIONS {
>>  	.ctors			0 : ALIGN(8) { *(SORT(.ctors.*)) *(.ctors) }
>>  	.init_array		0 : ALIGN(8) { *(SORT(.init_array.*)) *(.init_array) }
>>
>> +	.altinstructions	0 : ALIGN(8) { KEEP(*(.altinstructions)) }
>> +	__bug_table		0 : ALIGN(8) { KEEP(*(__bug_table)) }
>>  	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
>>
>>  	__patchable_function_entries : { *(__patchable_function_entries) }
>> --
>> 2.35.3
>>

