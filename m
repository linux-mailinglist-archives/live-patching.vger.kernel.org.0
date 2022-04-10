Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E51A4FAF5F
	for <lists+live-patching@lfdr.de>; Sun, 10 Apr 2022 19:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbiDJRuA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 10 Apr 2022 13:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiDJRt7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 10 Apr 2022 13:49:59 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E571548309;
        Sun, 10 Apr 2022 10:47:48 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id C66A22056568;
        Sun, 10 Apr 2022 10:47:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C66A22056568
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649612868;
        bh=ORQ6Dq/4sVu425G/r1dQy1TQTp07xI4u1wlSfHG4Sm0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Gu2wXzbb5VCg9KUde6+6w1mD7iGDFPVfDnFfwqC+VD5XAO06QFw4L6zqHpXKj9cR6
         5Bc9pPvM0fMX0A2cdVuNJ/T7S1oJUMdINKUf6FapXsORQ+YHl2vZFw3V8ixw3wZ2qD
         w5K+7YVEgSjHC4jqWEQ+8qDf2n+GE8NWhhXgLiYI=
Message-ID: <93b08ed3-80ca-4171-aaed-1513ae7cb0e1@linux.microsoft.com>
Date:   Sun, 10 Apr 2022 12:47:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <YlAUj6w6fePEo7v+@hirez.programming.kicks-ass.net>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YlAUj6w6fePEo7v+@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/8/22 05:55, Peter Zijlstra wrote:
> On Thu, Apr 07, 2022 at 03:25:09PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> [-- application/octet-stream is unsupported (use 'v' to view this part) --]
> 
> Your emails are unreadable :-(

I am not sure why the emails are unreadable. Any suggestions? Should I resend? Please let me know.
Sorry about this.

Madhavan
