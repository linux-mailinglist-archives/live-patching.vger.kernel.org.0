Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016D6229AC5
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 16:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgGVO4v (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 10:56:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39043 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732143AbgGVO4u (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 10:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595429809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gVk//BUazCMtzlozAWa7nTU6Yu6g/1ZlLTzqK6oLIM=;
        b=i4uLGmClG2UFEOkTbOZPY4wlpfNzommGt2S98eWYAd5Rq84XL5/RM7ftUpoGhUkt0ebAMZ
        vn5mdh35t6HQDdWyC5ELOI5iaZZxWHOrtHBRxII0CA48RCv1qKCjQKqd+5B6r9GWZTg+Xy
        e/PGHEKZjDddWlB3O6fxUDmb5K5Lre8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-mG0EkZpuPlCR4i706fgDDw-1; Wed, 22 Jul 2020 10:56:43 -0400
X-MC-Unique: mG0EkZpuPlCR4i706fgDDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F40419253C2;
        Wed, 22 Jul 2020 14:56:42 +0000 (UTC)
Received: from [10.10.114.255] (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B50615FC3B;
        Wed, 22 Jul 2020 14:56:40 +0000 (UTC)
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Kees Cook <keescook@chromium.org>, Miroslav Benes <mbenes@suse.cz>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <aa51eb26-e2a9-c448-a3b8-e9e68deeb468@redhat.com>
Message-ID: <b5bc7a92-a11e-d75d-eefb-fc640c87490d@redhat.com>
Date:   Wed, 22 Jul 2020 10:56:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <aa51eb26-e2a9-c448-a3b8-e9e68deeb468@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/22/20 10:51 AM, Joe Lawrence wrote:
> On 7/22/20 10:39 AM, Kees Cook wrote:
>> On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
>>> Let me CC live-patching ML, because from a quick glance this is something
>>> which could impact live patching code. At least it invalidates assumptions
>>> which "sympos" is based on.
>>
>> In a quick skim, it looks like the symbol resolution is using
>> kallsyms_on_each_symbol(), so I think this is safe? What's a good
>> selftest for live-patching?
>>
> 
> Hi Kees,
> 
> I don't think any of the in-tree tests currently exercise the
> kallsyms/sympos end of livepatching.
> 

On second thought, I mispoke.. The general livepatch code does use it:

klp_init_object
   klp_init_object_loaded
     klp_find_object_symbol

in which case any of the current kselftests should exercise that.

   % make -C tools/testing/selftests/livepatch run_tests

-- Joe

