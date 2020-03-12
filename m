Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A72183426
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2020 16:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgCLPLt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Mar 2020 11:11:49 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:14477 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbgCLPLt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Mar 2020 11:11:49 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2020 11:11:48 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1584025908;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=E/iioeUyGvUs2PCKR77Yq3QSzc2cyAnhIsuxWm1+EHU=;
  b=h20ntI3KTS4SeiXOMo7KMN6Gzy6Uo9XafIY0MA5XPkqcPcy6N8456UvT
   vhS4mCR7xfPCWgN07pKOSxDnjSg09IyYaW5lQWs0zcz1a8R0xjjpbUT6R
   JePY9v14CgsnlnnMj0itXRqfjr5HfullqlNLwmZpeDQPns2SQxQMOElN8
   M=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=andrew.cooper3@citrix.com; spf=Pass smtp.mailfrom=Andrew.Cooper3@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  andrew.cooper3@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="andrew.cooper3@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa1.hc3370-68.iphmx.com: domain of
  Andrew.Cooper3@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="Andrew.Cooper3@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: juTW57c1Nu9s/elcsbYtUaVbY4J0Q77f36sXCUBorbJPvEaGDjzf3fZzPIj3EP8OrxKujqz7de
 z7Tf+KC1CJJBGOkRcy9CcSVcEQngsMqY/l45AkANeecc2r3xHBzRjuMOu1ktP+L5hb4TLvW/Nw
 wU5DYgD1CXd/I+3JAxTFx8YCXKp9//kyfyw6f7bq9q+jSXIGL+8DawiAW9vuSe51mZUHoGiY0G
 xInV59drshdWYL3Z0QxIQyNQsg2ykjCRPuO+5yK/bwblyKqAMtvCeiLF+u4/eBKl4o07hAHnqu
 GII=
X-SBRS: 2.7
X-MesageID: 14034391
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.70,545,1574139600"; 
   d="scan'208";a="14034391"
Subject: Re: [Xen-devel] [PATCH 1/2] x86/xen: Make the boot CPU idle task
 reliable
To:     Miroslav Benes <mbenes@suse.cz>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <sstabellini@kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <jpoimboe@redhat.com>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <jslaby@suse.cz>
References: <20200312142007.11488-1-mbenes@suse.cz>
 <20200312142007.11488-2-mbenes@suse.cz>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <dc55b23b-c0d2-3be0-222f-d104548c8cf4@citrix.com>
Date:   Thu, 12 Mar 2020 15:04:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200312142007.11488-2-mbenes@suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL01.citrite.net (10.69.22.125)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12/03/2020 14:20, Miroslav Benes wrote:
> The unwinder reports the boot CPU idle task's stack on XEN PV as
> unreliable, which affects at least live patching. There are two reasons
> for this. First, the task does not follow the x86 convention that its
> stack starts at the offset right below saved pt_regs. It allows the
> unwinder to easily detect the end of the stack and verify it. Second,
> startup_xen() function does not store the return address before jumping
> to xen_start_kernel() which confuses the unwinder.
>
> Amend both issues by moving the starting point of initial stack in
> startup_xen() and storing the return address before the jump.
>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  arch/x86/xen/xen-head.S | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 1d0cee3163e4..642f346bfe02 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -35,7 +35,7 @@ SYM_CODE_START(startup_xen)
>  	rep __ASM_SIZE(stos)
>  
>  	mov %_ASM_SI, xen_start_info
> -	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
> +	mov $init_thread_union+THREAD_SIZE-SIZEOF_PTREGS, %_ASM_SP
>  
>  #ifdef CONFIG_X86_64
>  	/* Set up %gs.
> @@ -51,7 +51,9 @@ SYM_CODE_START(startup_xen)
>  	wrmsr
>  #endif
>  
> +	push $1f
>  	jmp xen_start_kernel
> +1:

Hang on.  Isn't this just a `call` instruction written in longhand?

~Andrew
