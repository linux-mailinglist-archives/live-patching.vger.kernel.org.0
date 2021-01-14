Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569F62F6F36
	for <lists+live-patching@lfdr.de>; Fri, 15 Jan 2021 01:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbhAOAAI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Jan 2021 19:00:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731027AbhAOAAH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Jan 2021 19:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610668721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+GQ2A1tJkR5nZDKYaDuSsXqzWGBYLX3xNX/Oddef9lI=;
        b=O+ADg2kGi2ETufWX2LjoFD28CQ206AUtpTP2tS441GeoVQ5Kr2dUXaPbzocx9dOIYJ48MC
        xcAyvmRbSKR3+3v8UWhjN2lmWxK879KyroYhjKDoA4EJiPSEmSM55InBYiAVjqfAvXu+9s
        2m5L43a0u16rXPUkR/zGT2SisLF7g84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-Tp1X1MAvMmmCWkQKUlLjCA-1; Thu, 14 Jan 2021 18:58:40 -0500
X-MC-Unique: Tp1X1MAvMmmCWkQKUlLjCA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF7D615722;
        Thu, 14 Jan 2021 23:58:38 +0000 (UTC)
Received: from treble (ovpn-120-156.rdu2.redhat.com [10.10.120.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D8DB19C45;
        Thu, 14 Jan 2021 23:58:36 +0000 (UTC)
Date:   Thu, 14 Jan 2021 17:58:32 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Live patching on ARM64
Message-ID: <20210114235832.lqdrgb3yeeg2n4fg@treble>
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

I'd also recommend subscribing to the live-patching mailing list (Cc'ed).

On Thu, Jan 14, 2021 at 04:07:55PM -0600, Madhavan T. Venkataraman wrote:
> Hi all,
> 
> My name is Madhavan Venkataraman.
> 
> Microsoft is very interested in Live Patching support for ARM64.
> On behalf of Microsoft, I would like to contribute.
> 
> I would like to get in touch with the people who are currently working
> in this area, find out what exactly they are working on and see if they
> could use an extra pair of eyes/hands with what they are working on.
> 
> It looks like the most recent work in this area has been from the
> following folks:
> 
> Mark Brown and Mark Rutland:
> 	Kernel changes to providing reliable stack traces.
> 
> Julien Thierry:
> 	Providing ARM64 support in objtool.
> 
> Torsten Duwe:
> 	Ftrace with regs.
> 
> I apologize if I have missed anyone else who is working on Live Patching
> for ARM64. Do let me know.
> 
> Is there any work I can help with? Any areas that need investigation, any code
> that needs to be written, any work that needs to be reviewed, any testing that
> needs to done? You folks are probably super busy and would not mind an extra
> hand.
> 
> I have subscribed to linux-arm-kernel. But if any discussions should happen on
> another mailing list, could you please CC me? Appreciate it.
> 
> Thanks! I look forward to working with you.
> 
> Madhavan
> 
> P.S.:
> 
> Julien,
> 
> Could you send me a link to your latest RFC submission? Thanks!

-- 
Josh

